echo "mkdir -p $YPMAPDIR/$DOMAIN"; \
mkdir -p $YPMAPDIR/$DOMAIN; \
echo "echo $HOST >$YPMAPDIR/ypservers" ;\
echo $HOST >$YPMAPDIR/ypservers; \
echo "$YPMAPDIR/ypservers | awk '{print $$0, $$0}' | $YPBINDIR/makedbm - $YPMAPDIR/$DOMAIN/ypservers"; \
cat $YPMAPDIR/ypservers | awk '{print $$0, $$0}' | $YPBINDIR/makedbm - $YPMAPDIR/$DOMAIN/ypservers; \
echo "cd $YPMAPDIR && make NOPUSH=true"; \
cd $YPMAPDIR && make NOPUSH=true; 
