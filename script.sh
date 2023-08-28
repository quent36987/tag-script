#! /bin/bash

MYPATH="/mnt/c/Users/Quentin/Desktop/S9/tag-script"

trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}


find_max_tag_number() {

tag_prefix="$1"
max_number=0

      while IFS='-' read -r line; do
              tag=""
              number=""

             tag="${line%-*}" # Extraire le tag (en supprimant le dernier segment numérique)
             number="${line##*-}" # Extraire le numéro (en supprimant tout avant le dernier tiret)
            number=$(trim "$number") #
            tag="$tag-"

             if [[ "$tag" == "$tag_prefix" ]] && [[ "$number" =~ ^[0-9]+$ ]]  && [[ "$number" -gt "$max_number" ]]; then
                 max_number="$number"
             fi
    done < "$MYPATH/all_tags.txt"

    echo "$max_number"
}



arg1=$1

if [ -z "$1" ]; then
  echo "No argument supplied"
  # Get the last_tag.txt tag with the file last_tag.txt and version with last_version.txt
  last_tag=$(cat "$MYPATH/last_tag.txt")
  echo "Last tag: $last_tag"
  last_version=$(find_max_tag_number "$last_tag")

  # Increment the version
  new_version=$(($last_version + 1))

  # ask if the new tag is ok
  read -p "New tag: $last_tag$new_version ? (y/n) " reply

  if [[ $reply =~ ^[Yy]$ ]]; then
    echo "New tag: $last_tag$new_version"
    arg1=$last_tag
    arg2=$new_version
  else
    echo "exit"
    exit 1
  fi

  else
    last_version=$(find_max_tag_number "$arg1")

      # Increment the version
      new_version=$(($last_version + 1))

      # ask if the new tag is ok
      read -p "New tag: $arg1$new_version ? (y/n) " reply

      if [[ $reply =~ ^[Yy]$ ]]; then
        echo "New tag: $arg1$new_version"
        arg2=$new_version
      else
        echo "exit"
        exit 1
      fi
fi




if ! git diff --cached --name-status | grep -qE '^[A|M]'; then
  echo "No file to commit"
  git status
  read -p "Do you want to add . ? (y/n) " reply
  if [[ $reply =~ ^[Yy]$ ]]; then
    git add .
  else
    echo "exit"
    exit 1
  fi
fi

echo "Argument supplied: $arg1 et $arg2"

# stock tag and version in file

echo $arg1 > "$MYPATH/last_tag.txt"
# add the tag to all_tags.txt
echo $arg1$arg2 >> "$MYPATH/all_tags.txt"

#
git commit -m "commit-$arg2"
git tag -a "$arg1$arg2" -m "tag-$arg2"
git push --follow-tags
