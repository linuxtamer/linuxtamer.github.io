
Underscore folfer hidden at github server!
run: 

find . -type f -exec sed -i 's/_static/static/g' {} +
mv _static static
