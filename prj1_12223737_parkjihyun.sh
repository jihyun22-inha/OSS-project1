#!/bin/bash

echo "--------------------------"
echo "User Name: ParkJiHyun"
echo "Student Number: 12223737"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.data'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

while true; do
read -p "Enter your choice [ 1-9 ] " choice
echo " "

case $choice in

1)
read -p "Please enter 'movie id' (1~1682): " movie_id
echo " "
cat u.item | awk -F '|' -v movie_id="$movie_id" '$1 == movie_id {print $0}'
;;

2)
read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n): " answer
echo " "
awk -F '|' '$7 ~ /1/ {print $1, $2}' u.item | head -n 10
;;

3)
read -p "Please enter the 'movie id' (1~1682): " movie_id
echo " "
echo "average rating of 'movie id' $movie_id: $(awk -F '\t' -v movie_id="$movie_id" '$2 == movie_id { sum += $3; count++ } END { printf "%.5f", sum / count; }' u.data)"
;;

4)
read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n): " answer
echo " "
cat u.item | sed 's/http:\/\/us.imdb.com\/[^|]*|/|/g' | head -n 10
;;

5)
read -p "Do you want to get the data about users from 'u.user'? (y/n): " answer
echo " "
cat u.user | sed -n -E '1,10 s/([0-9]+)\|([0-9]+)\|([MF])\|([^|]+)\|([0-9]+)/user \1 is \2 years old \3 \4/p' | sed 's/M/male/g; s/F/female/g'
;;

6)
read -p "Do you want to Modify the format of 'release data' in 'u.item'? (y/n): " answer
echo " "
cat u.item | sed -E 's/([0-9]+)-Jan-([0-9]+)/\201\1/; s/([0-9]+)-Feb-([0-9]+)/\202\1/; s/([0-9]+)-Mar-([0-9]+)/\203\1/; s/([0-9]+)-Apr-([0-9]+)/\204\1/; s/([0-9]+)-May-([0-9]+)/\205\1/; s/([0-9]+)-Jun-([0-9]+)/\206\1/; s/([0-9]+)-Jul-([0-9]+)/\207\1/; s/([0-9]+)-Aug-([0-9]+)/\208\1/; s/([0-9]+)-Sep-([0-9]+)/\209\1/; s/([0-9]+)-Oct-([0-9]+)/\210\1/; s/([0-9]+)-Nov-([0-9]+)/\211\1/; s/([0-9]+)-Dec-([0-9]+)/\212\1/' | tail -n 10
;;

7)
read -p "Please enter the 'user id' (1~943): " user_id
echo " "
cat u.data | awk -v user_id="$user_id" '$1 == user_id {print $2}' | sort -n | tr '\n' '|' | sed 's/|$//'
printf "\n\n"
movies=($(cat u.data | awk -v user_id="$user_id" '$1 == user_id {print $2}' | sort -n | head -10))
for m in "${movies[@]}"
do
cat u.item | sed 's/^\([^|]*|[^|]*\).*$/\1/' | sed -n "${m}p"
done
;;

8)
read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n): " answer
echo " "
programmers=$(awk -F "|" '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1}' u.user)
for user_id in $programmers
do
awk -v user="$user_id" -F"\t" '$1 == user {print $2, $3}' u.data
done | awk '{arr[$1]+=$2; count[$1]++} END {for (i in arr) {printf "%s %.6g\n", i, arr[i]/count[i]}}' | sort -n
;;

9)
echo "Bye!"
exit
;;

*)
echo "Please enter a valid option [ 1-9 ]."
;;

esac
echo " "
done
