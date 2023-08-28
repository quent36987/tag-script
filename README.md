```sh
git clone
cd tag-script
chmod +x script.sh
chmod +wr all_tags.txt last_tag.tkt
```

dans script.sh :
mettre le bon chemin vers ce dossier :
````
MYPATH="/mnt/c/Users/Quentin/Desktop/S9/tag-script"
````

et dans le .bashrc :
````
export PATH="/mnt/c/Users/Quentin/Desktop/S9/tag-script/:$PATH"
alias tag="script.sh"
````

````sh
source .bashrc
````



