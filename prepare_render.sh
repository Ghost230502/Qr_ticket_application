#!/bin/bash
set -e

# 💡 Configuration : change ces valeurs
GITHUB_URL="https://github.com/Ghost230502/Qr_ticket_application.git"
GIT_BRANCH="main"

echo "🔧 Installation de gunicorn et génération de requirements.txt..."
pip install gunicorn
pip freeze > requirements.txt

echo "⚙️ Création du Procfile..."
cat > Procfile <<EOF
web: gunicorn app:app
EOF

echo "📄 Création du .gitignore..."
cat > .gitignore <<EOF
__pycache__/
*.pyc
.env
*.db
.vscode/
EOF

echo "🛠️ Initialisation Git (si nécessaire)..."
if [ ! -d .git ]; then
  git init
  git remote add origin "$GITHUB_URL"
fi

echo "📝 Ajout et commit des fichiers..."
git add requirements.txt Procfile .gitignore
git commit -m "Préparation déploiement Render: add gunicorn, Procfile, gitignore" || echo "Pas de modifications à committer"

echo "🚀 Push vers GitHub ($GIT_BRANCH)..."
git branch -M $GIT_BRANCH
git push -u origin $GIT_BRANCH

echo "✅ Tout est prêt. Va maintenant sur Render pour déployer avec build : pip install -r requirements.txt et start : gunicorn app:app"
