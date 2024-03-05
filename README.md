# flutter_halloffame

A hall of fame live interactive website for Hamburg Area School District.

## Deploying

flutter clean
flutter pub get

flutter build web --base-href /hasd-hall-of-fame/ --release

cd build/web
git init
git add .
git commit -m "Deploy 5"
git branch -M main
git remote add origin https://github.com/MrKing-dev/hasd-hall-of-fame.git
git push -u --force origin main

