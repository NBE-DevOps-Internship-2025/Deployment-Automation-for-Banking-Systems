# DevOps Deployment Safety Toolkit

Enterprise-grade tools for reliable deployments across any infrastructure. Validates resources, creates traceable backups, and maintains clean environments.

## 🌟 Key Features

### 🛡️ Deployment Safety
- **Pre-Deployment Checks**  
  - Verifies server disk space vs package requirements  
  - Calculates extraction size before execution  
  - Fails early with clear warnings  

### 🔄 Intelligent Backups
- **Full Snapshots**  
  Complete system backups with timestamp/Git metadata  
- **Incremental Backups**  
  Git-aware, only captures changed files  
  Preserves full directory structures  

### 🧼 Environment Cleanup
- Targets deployment directories while protecting critical files  
- Safety-first design with dry-run mode  
- Interactive confirmation  

## 🖥️ Usage

```bash
# Run space verification
./deployment/Pre_Deployment_Storage_Check.sh

# Create incremental backup
./backups/backup.ps1

## 🏗️ Ideal For
CI/CD pipelines needing pre-deployment checks

Teams requiring rollback-safe workflows

Any project with strict resource constraints

🔧 Developed during National Bank of Egypt's 2025 DevOps program
