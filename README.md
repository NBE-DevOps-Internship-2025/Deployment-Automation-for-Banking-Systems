# Banking DevOps Automation Toolkit

Production-grade deployment safety tools for financial systems. Validates server resources, creates traceable backups, and maintains clean deployment environments.

## 🚀 Core Features

### 🔍 Pre-Deployment Verification
- Checks available server disk space against deployment package requirements
- Calculates extraction size before deployment
- Fails safely with clear warnings

### 🔄 Smart Backup System
- **Full snapshots**: Complete repo backups with timestamp/Git metadata
- **Incremental backups**: Only changed files (Git-aware)
- Preserves directory structure

### 🧹 Secure Cleanup
- Targets `deploy_*` directories while protecting `.zip` files
- Dry-run mode for safety verification
- Interactive confirmation

## 💻 Usage

```bash
# Check deployment space (Bash)
./deployment/Pre_Deployment_Storage_Check.sh

# Create backup (PowerShell)
./backups/backup.ps1
🏛️ Designed For
Banking systems requiring audit-compliant deployments

Environments with strict resource constraints

Teams needing rollback-safe deployment workflows

📌 Developed during National Bank of Egypt's 2025 DevOps internship# Deployment-Automation-for-Banking-Systems
