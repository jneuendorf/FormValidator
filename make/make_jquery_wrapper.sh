echo '(function($){' | cat - $1 > temp && mv temp $1
echo '})(jQuery)' >> $1
