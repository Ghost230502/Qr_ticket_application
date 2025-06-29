@echo off
REM === CONFIGURATION ===
set GITHUB_URL=https://github.com/Ghost230502/Qr_ticket_application.git
set GIT_USERNAME=El Hadji
set GIT_EMAIL=elhadji@example.com

REM === CONFIGURATION GIT ===
echo 📌 Configuration Git...
git config --global user.name "%GIT_USERNAME%"
git config --global user.email "%GIT_EMAIL%"

REM === INITIALISATION ===
echo 🛠️ Initialisation du dépôt...
git init

REM === AJOUT DES FICHIERS ===
echo 📦 Ajout des fichiers...
git add .

REM === COMMIT INITIAL ===
echo ✅ Création du commit initial...
git commit -m "Initial commit"

REM === BRANCHE PRINCIPALE ===
echo 🌿 Création de la branche principale main...
git branch -M main

REM === AJOUT DU DEPOT DISTANT ===
echo 🔗 Lien avec GitHub...
git remote add origin %GITHUB_URL%

REM === PUSH VERS GITHUB ===
echo 🚀 Envoi vers GitHub...
git push -u origin main

echo ✅ Terminé ! Vérifie sur GitHub : %GITHUB_URL%
pause
