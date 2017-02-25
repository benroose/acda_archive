sed -n "
/Beginning of block/,/End of block/ {
   N
   /End of block/ { 
      s/some_pattern/&/p
      }
   }"
