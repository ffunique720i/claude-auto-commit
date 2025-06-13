#!/usr/bin/env node
import { query } from "@anthropic-ai/claude-code";
import { exec } from 'child_process';
import { promisify } from 'util';
import fs from 'fs/promises';
import path from 'path';
import os from 'os';

const execAsync = promisify(exec);

class ClaudeAutoCommit {
  constructor(options = {}) {
    this.language = options.language || 'en';
    this.useEmoji = options.useEmoji || false;
    this.conventionalCommit = options.conventionalCommit || false;
    this.commitType = options.commitType || '';
    this.dryRun = options.dryRun || false;
    this.verbose = options.verbose || false;
    this.push = options.push || false;
    this.templateName = options.templateName || '';
    this.maxRetries = options.maxRetries || 3;
    this.timeout = options.timeout || 30000;
    // Cache for git command results to avoid duplicate calls
    this._gitCache = {};
    // Cache for config file to avoid repeated filesystem access
    this._configCache = null;
    this._configCacheTime = 0;
    this.CONFIG_CACHE_TTL = 5 * 60 * 1000; // 5分間キャッシュ
  }

  // パフォーマンス測定ユーティリティ
  async measure(name, fn) {
    if (!this.verbose) {
      return await fn();
    }
    
    const start = process.hrtime.bigint();
    const result = await fn();
    const end = process.hrtime.bigint();
    const duration = Number(end - start) / 1e6; // ミリ秒
    
    console.log(`⏱️  ${name}: ${duration.toFixed(2)}ms`);
    return result;
  }

  async loadConfig() {
    try {
      // Check cache first
      const now = Date.now();
      if (this._configCache && (now - this._configCacheTime) < this.CONFIG_CACHE_TTL) {
        if (this.verbose) {
          console.log('📄 Configuration loaded from cache');
        }
        return this._configCache;
      }

      const configPath = path.join(os.homedir(), '.claude-auto-commit', 'config.json');
      const configExists = await fs.access(configPath).then(() => true).catch(() => false);
      
      if (configExists) {
        const configContent = await fs.readFile(configPath, 'utf8');
        const config = JSON.parse(configContent);
        
        // Cache the config
        this._configCache = config;
        this._configCacheTime = now;
        
        // 設定ファイルからデフォルト値を適用
        this.language = this.language || config.language || 'en';
        this.useEmoji = this.useEmoji || config.useEmoji || false;
        this.conventionalCommit = this.conventionalCommit || config.conventionalCommit || false;
        this.verbose = this.verbose || config.verbose || false;
        
        if (this.verbose) {
          console.log('📄 Configuration loaded from:', configPath);
        }
        
        return config;
      }
    } catch (error) {
      if (this.verbose) {
        console.log('⚠️  No configuration file found, using defaults');
      }
    }
    return null;
  }

  async saveTemplate(name, message) {
    try {
      const templatesDir = path.join(os.homedir(), '.claude-auto-commit', 'templates');
      await fs.mkdir(templatesDir, { recursive: true });
      
      const templatePath = path.join(templatesDir, `${name}.txt`);
      await fs.writeFile(templatePath, message, 'utf8');
      
      console.log(`💾 Template saved: ${name}`);
    } catch (error) {
      console.error(`❌ Failed to save template: ${error.message}`);
    }
  }

  async loadTemplate(name) {
    try {
      const templatePath = path.join(os.homedir(), '.claude-auto-commit', 'templates', `${name}.txt`);
      const template = await fs.readFile(templatePath, 'utf8');
      return template.trim();
    } catch (error) {
      throw new Error(`Template "${name}" not found`);
    }
  }

  async listTemplates() {
    try {
      const templatesDir = path.join(os.homedir(), '.claude-auto-commit', 'templates');
      const files = await fs.readdir(templatesDir);
      return files.filter(f => f.endsWith('.txt')).map(f => f.replace('.txt', ''));
    } catch (error) {
      return [];
    }
  }

  async checkGitRepository() {
    try {
      await execAsync('git rev-parse --git-dir');
      return true;
    } catch (error) {
      throw new Error('Not a git repository. Please run this command in a git repository.');
    }
  }

  async checkForChanges() {
    try {
      const { stdout: status } = await execAsync('git status --porcelain', { maxBuffer: 1024 * 1024 });
      // Cache the status result for potential reuse in getGitChanges()
      this._gitCache.status = status;
      return status.trim().length > 0;
    } catch (error) {
      throw new Error(`Failed to check git status: ${error.message}`);
    }
  }

  async getGitChanges() {
    try {
      // Use cached status if available, otherwise execute all commands in parallel
      let statusPromise;
      if (this._gitCache.status !== undefined) {
        statusPromise = Promise.resolve({ stdout: this._gitCache.status });
      } else {
        statusPromise = execAsync('git status --porcelain', { maxBuffer: 1024 * 1024 });
      }

      // Execute git commands in parallel for better performance
      const [statusResult, branchResult, diffResult, diffUnstagedResult] = await Promise.all([
        statusPromise,
        execAsync('git branch --show-current', { maxBuffer: 1024 * 1024 }),
        execAsync('git diff --cached --name-only', { maxBuffer: 1024 * 1024 }),
        execAsync('git diff --name-only', { maxBuffer: 1024 * 1024 })
      ]);

      const status = statusResult.stdout;
      const branch = branchResult.stdout;
      const diff = diffResult.stdout;
      const diffUnstaged = diffUnstagedResult.stdout;

      // Cache branch result for potential reuse in pushChanges()
      this._gitCache.branch = branch;

      if (!status.trim()) {
        throw new Error('No changes detected');
      }
      
      let changes = `Branch: ${branch.trim()}\n\nStatus:\n${status}\n\n`;
      
      // Prepare promises for stats commands if needed
      const statsPromises = [];
      const statsTypes = [];
      
      if (diff.trim()) {
        changes += `Staged files:\n${diff}\n`;
        statsPromises.push(execAsync('git diff --cached --stat', { maxBuffer: 1024 * 1024 }));
        statsTypes.push('staged');
      }
      
      if (diffUnstaged.trim()) {
        changes += `Unstaged files:\n${diffUnstaged}\n`;
        statsPromises.push(execAsync('git diff --stat', { maxBuffer: 1024 * 1024 }));
        statsTypes.push('unstaged');
      }
      
      // Execute stats commands in parallel if any
      if (statsPromises.length > 0) {
        const statsResults = await Promise.allSettled(statsPromises);
        
        statsResults.forEach((result, index) => {
          const type = statsTypes[index];
          if (result.status === 'fulfilled') {
            if (type === 'staged') {
              changes += `\nStaged changes summary:\n${result.value.stdout}\n\n`;
            } else {
              changes += `\nUnstaged changes summary:\n${result.value.stdout}\n`;
            }
          } else {
            if (type === 'staged') {
              changes += `\nStaged changes: (too large to display)\n\n`;
            } else {
              changes += `\nUnstaged changes: (too large to display)\n`;
            }
          }
        });
      }

      // 大きすぎる場合は切り詰める
      if (changes.length > 4000) {
        changes = changes.substring(0, 4000) + '\n... (truncated for brevity)';
      }

      return changes;
    } catch (error) {
      throw new Error(`Failed to get git changes: ${error.message}`);
    }
  }

  async generateCommitMessage(changes) {
    const prompt = this.buildPrompt(changes);
    
    for (let attempt = 1; attempt <= this.maxRetries; attempt++) {
      try {
        if (this.verbose) {
          console.log(`🤖 Generating commit message (attempt ${attempt}/${this.maxRetries})...`);
        }
        
        const messages = [];
        const abortController = new AbortController();
        const timeoutId = setTimeout(() => abortController.abort(), this.timeout);
        
        for await (const message of query({
          prompt: prompt,
          abortController,
          options: {
            maxTurns: 1,
          },
        })) {
          messages.push(message);
        }
        
        clearTimeout(timeoutId);
        
        // 結果を取得
        const resultMessage = messages.find(msg => msg.type === 'result');
        if (resultMessage && resultMessage.result) {
          return resultMessage.result.trim();
        }
        
        // assistantメッセージからも試行
        const assistantMessage = messages.find(msg => msg.type === 'assistant');
        if (assistantMessage && assistantMessage.message && assistantMessage.message.content) {
          const content = assistantMessage.message.content;
          if (Array.isArray(content) && content[0] && content[0].text) {
            return content[0].text.trim();
          }
        }
        
        throw new Error('No valid response received from Claude');
        
      } catch (error) {
        if (error.name === 'AbortError') {
          console.log(`⏱️  Attempt ${attempt} timed out`);
        } else {
          console.log(`❌ Attempt ${attempt} failed: ${error.message}`);
        }
        
        if (attempt === this.maxRetries) {
          throw new Error(`Failed to generate commit message after ${this.maxRetries} attempts: ${error.message}`);
        }
        
        // 指数バックオフで待機
        const delay = Math.min(1000 * Math.pow(2, attempt - 1), 10000);
        console.log(`⏳ Retrying in ${delay}ms...`);
        await new Promise(resolve => setTimeout(resolve, delay));
      }
    }
  }

  buildPrompt(changes) {
    let prompt;
    
    if (this.language === 'ja') {
      prompt = `以下のGit変更内容に基づいて、適切なコミットメッセージを生成してください。`;
      
      if (this.conventionalCommit) {
        prompt += ` Conventional Commits形式（例：feat:, fix:, docs:, style:, refactor:, test:, chore:）を使用してください。`;
        if (this.commitType) {
          prompt += ` コミットタイプは "${this.commitType}" を使用してください。`;
        }
      }
      
      if (this.useEmoji) {
        prompt += ` 適切な絵文字を含めてください。`;
      }
      
      prompt += ` コミットメッセージのみを出力してください。説明や追加のテキストは不要です。`;
      
    } else {
      prompt = `Generate an appropriate git commit message based on the following changes.`;
      
      if (this.conventionalCommit) {
        prompt += ` Use Conventional Commits format (e.g., feat:, fix:, docs:, style:, refactor:, test:, chore:).`;
        if (this.commitType) {
          prompt += ` Use "${this.commitType}" as the commit type.`;
        }
      }
      
      if (this.useEmoji) {
        prompt += ` Include appropriate emojis.`;
      }
      
      prompt += ` Output only the commit message. No explanation or additional text needed.`;
    }
    
    prompt += `\n\nChanges:\n${changes}`;
    
    return prompt;
  }

  async stageAllChanges() {
    try {
      await execAsync('git add .');
      if (this.verbose) {
        console.log('📁 All changes staged');
      }
    } catch (error) {
      throw new Error(`Failed to stage changes: ${error.message}`);
    }
  }

  async createCommit(message) {
    try {
      // メッセージをエスケープ
      const escapedMessage = message.replace(/"/g, '\\"').replace(/\$/g, '\\$');
      await execAsync(`git commit -m "${escapedMessage}"`);
      return true;
    } catch (error) {
      throw new Error(`Failed to create commit: ${error.message}`);
    }
  }

  async pushChanges() {
    try {
      // Use cached branch if available, otherwise get it
      let currentBranch;
      if (this._gitCache.branch !== undefined) {
        currentBranch = this._gitCache.branch.trim();
      } else {
        const { stdout: branch } = await execAsync('git branch --show-current');
        currentBranch = branch.trim();
      }
      
      console.log(`🚀 Pushing to ${currentBranch}...`);
      await execAsync(`git push origin ${currentBranch}`);
      console.log('✅ Changes pushed successfully!');
    } catch (error) {
      console.error(`❌ Failed to push changes: ${error.message}`);
      console.log('💡 You may need to push manually: git push');
    }
  }

  async showStatistics() {
    try {
      const { stdout: logOutput } = await execAsync('git log --oneline -10');
      console.log('\n📊 Recent commits:');
      console.log(logOutput);
    } catch (error) {
      if (this.verbose) {
        console.log('⚠️  Could not retrieve commit history');
      }
    }
  }

  async run() {
    const totalStart = this.verbose ? process.hrtime.bigint() : null;
    
    try {
      console.log('🚀 Claude Auto Commit (SDK Version v0.1.0)');
      
      // 設定読み込みとgitリポジトリチェックを並列実行
      const [config] = await this.measure('Config and Git setup', async () => {
        return await Promise.all([
          this.loadConfig(),
          this.checkGitRepository()
        ]);
      });
      
      const hasChanges = await this.measure('Change detection', () => this.checkForChanges());
      if (!hasChanges) {
        console.log('✨ No changes detected. Repository is clean.');
        return;
      }
      
      await this.measure('Staging changes', () => this.stageAllChanges());
      
      const changes = await this.measure('Git changes analysis', () => this.getGitChanges());
      
      if (this.verbose) {
        console.log('🔍 Analyzing changes with Claude Code SDK...');
      }
      
      // テンプレート使用の場合
      let commitMessage;
      if (this.templateName) {
        try {
          commitMessage = await this.loadTemplate(this.templateName);
          console.log(`📋 Using template: ${this.templateName}`);
        } catch (error) {
          console.log(`⚠️  ${error.message}, generating new message...`);
          commitMessage = await this.measure('Commit message generation', () => this.generateCommitMessage(changes));
        }
      } else {
        commitMessage = await this.measure('Commit message generation', () => this.generateCommitMessage(changes));
      }
      
      console.log(`\n📝 Generated commit message:`);
      console.log(`"${commitMessage}"`);
      
      if (this.dryRun) {
        console.log('\n🔍 Dry run mode - commit not created');
        
        // テンプレート保存オプション
        if (process.argv.includes('--save-template')) {
          const templateName = process.argv[process.argv.indexOf('--save-template') + 1];
          if (templateName) {
            await this.saveTemplate(templateName, commitMessage);
          }
        }
        return;
      }
      
      await this.createCommit(commitMessage);
      console.log('\n✅ Commit created successfully!');
      
      if (this.push) {
        await this.pushChanges();
      }
      
      if (this.verbose) {
        await this.showStatistics();
        
        // 総実行時間を表示
        if (totalStart) {
          const totalEnd = process.hrtime.bigint();
          const totalDuration = Number(totalEnd - totalStart) / 1e6; // ミリ秒
          console.log(`\n⏱️  Total execution time: ${totalDuration.toFixed(2)}ms`);
        }
      }
      
    } catch (error) {
      console.error(`❌ Error: ${error.message}`);
      
      if (this.verbose) {
        console.error('Stack trace:', error.stack);
      }
      
      process.exit(1);
    }
  }
}

function parseArgs() {
  const args = process.argv.slice(2);
  const options = {};
  
  for (let i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '-l':
      case '--language':
        options.language = args[++i];
        break;
      case '-e':
      case '--emoji':
        options.useEmoji = true;
        break;
      case '-c':
      case '--conventional':
        options.conventionalCommit = true;
        break;
      case '-t':
      case '--type':
        options.commitType = args[++i];
        options.conventionalCommit = true; // 自動的にconventional形式を有効化
        break;
      case '-d':
      case '--dry-run':
        options.dryRun = true;
        break;
      case '-v':
      case '--verbose':
        options.verbose = true;
        break;
      case '-p':
      case '--push':
        options.push = true;
        break;
      case '--template':
        options.templateName = args[++i];
        break;
      case '--save-template':
        // 引数を消費しない（run()メソッドで処理）
        break;
      case '--list-templates':
        (async () => {
          const autoCommit = new ClaudeAutoCommit();
          const templates = await autoCommit.listTemplates();
          console.log('📋 Available templates:');
          if (templates.length === 0) {
            console.log('  No templates found');
          } else {
            templates.forEach(template => console.log(`  - ${template}`));
          }
          process.exit(0);
        })();
        return;
      case '--version':
        console.log('Claude Auto Commit v0.1.2');
        process.exit(0);
      case '-h':
      case '--help':
        console.log(`
Claude Auto Commit (SDK Version v0.1.2)

Usage: node src/claude-auto-commit.js [options]

Options:
  -l, --language <lang>       Language for commit message (en, ja)
  -e, --emoji                Include emojis in commit message
  -c, --conventional         Use Conventional Commits format
  -t, --type <type>          Specify commit type (feat, fix, docs, etc.)
  -d, --dry-run              Preview commit message without creating commit
  -v, --verbose              Verbose output
  -p, --push                 Push changes after commit
  --template <name>          Use saved template
  --save-template <name>     Save generated message as template (dry-run only)
  --list-templates           List available templates
  --version                  Show version information
  -h, --help                 Show this help message

Examples:
  node src/claude-auto-commit.js
  node src/claude-auto-commit.js -l ja -e -c
  node src/claude-auto-commit.js -t feat --push
  node src/claude-auto-commit.js --dry-run --save-template my-template
  node src/claude-auto-commit.js --template my-template

Configuration:
  Create ~/.claude-auto-commit/config.json for default settings:
  {
    "language": "ja",
    "useEmoji": true,
    "conventionalCommit": true,
    "verbose": false
  }
        `);
        process.exit(0);
        break;
    }
  }
  
  return options;
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const options = parseArgs();
  const autoCommit = new ClaudeAutoCommit(options);
  autoCommit.run();
}

export default ClaudeAutoCommit;