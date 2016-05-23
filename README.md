# FFA

* Ubuntu 14.04 sunucuya kurulum için hazırladığımız bash scriptlerini belirtilen şekilde sunucunuzda çalıştırırsanız hızlıca 
bir CTF sistemine sahip olabilirsiniz :)
* Sunucunuza ssh ile bağlanın ve altta verilen adımları sırası ile yapınız.

```bash
  sudo su root
  cd
  vi server_prepare.sh (vi ile giriş yaptıktan sonra :set mouse=r yazıp enter'layınız. Ardından i'ye basınız. Ve server_prepare.sh dosyasının içinde ki komutları mouse sağ tuşa tıklayarak yapıştırınız. Ardından esc'ye basıp :wq yazıp enterlayınız.)
  chmod +x server_prepare.sh
  ./server_prepare.sh

  su deploy
  cd
  vi deploy_user.sh (vi ile giriş yaptıktan sonra :set mouse=r yazıp enter'layınız. Ardından i'ye basınız. Ve deploy_user.sh dosyasının içinde ki komutları mouse sağ tuşa tıklayarak yapıştırınız. Ardından esc'ye basıp :wq yazıp enterlayınız.)
  chmod +x deploy_user.sh
  ./deploy_user.sh
````

* Public Key: 'den sonra yazan değeri alıp lütfen oluşturduğunuz deponuza deployment key olarak ekleyiniz.
* Kendi makinamızda ffa klasöründe(Kendi makinamızda ruby 2.2.3 ve bundler kurulu olması gerekmekte);
* Sırası ile çalıştırınız ve gerekli bilgileri doldurunuz;
```bash
  bundle install
  bundle update
  bundle exec rake deploy:prepare
  bundle exec rake deploy:set
```
* app/views içinde bulunan klasörlerde ki dosyalardan görünüm ile ilgili düzenlemeler yapabilirsiniz.
* bu dosyalarda değişikliklerimizi yaptığımıza göre bu değişikliklerimizi repomuza kayıt edelim.
* ve şimdi sunucumuzu hazırlamak için komutumuzu çalıştıralım.

```bash 
  rm -rf .git
  git init
  git remote add origin REPO_URL
  git add .
  git commit -m "Commit message"
  git push -u origin master
  bundle exec cap production deploy:prepare
  bundle exec cap production deploy
  bundle exec cap production db:seed
```

* Ve artık sistemimiz hazır şimdi domain/admin den ffa@adeosecurity.com asdqwe123 bilgileri ile giriş yapabilirsiniz :)
