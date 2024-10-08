# Generate jks file
```
keytool -genkey -v -keystore android\app\forexmountain.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000  -alias upload
```

### Password 
 - forexmountain


## Test release apk

```    
fvm flutter build apk --release
```

# Build .aab

```
fvm flutter build appbundle --release
```

