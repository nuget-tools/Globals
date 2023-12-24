#! /usr/bin/env bash
set -uvx
set -e
cwd=`pwd`
ts=`date "+%Y.%m%d.%H%M.%S"`
version="${ts}"
cd $cwd/Globals
#sed -i -e "s/<Version>.*<\/Version>/<Version>${version}<\/Version>/g" Globals.csproj
rm -rf obj bin
dotnet build -c Rlease
cd $cwd/Globals.Main
dotnet run -c Release -f net462
dotnet run -c Release -f net6.0
cd $cwd
echo "# Globals" > README.md
echo "" >> README.md
echo "\`\`\`" >> README.md
iconv -f cp932 -t utf-8 Globals.Main/Program.cs >> README.md
echo "\`\`\`" >> README.md

exit 0

cd $cwd/Globals
sed -i -e "s/<Version>.*<\/Version>/<Version>${version}<\/Version>/g" Globals.csproj
rm -rf obj bin
rm -rf *.nupkg
dotnet pack -c Rlease -o .
cd $cwd
git add .
git commit -m"Globals v$version"
git tag -a v$ts -mv$version
git push origin v$version
git push
git remote -v
