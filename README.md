# Duyuru

Senior Flutter Developer ihtiyacımız var. İlgilenenler onboarding için Discord üzerinden HR ile iletişime geçebilir. HR listesi:

- Tuba Habalı#0725
- arzuozkan#0452
- mugeekilic#7288
- Buse Yalçın#2338

## Yardım Ağı Projesi

Bu uygulama, ihtiyaç sahibi depremzedelerin hangi adreste, nelere ihtiyaçları olduğu ve iletişim alma yöntemi bilgilerini ekleyebildiği; aynı zamanda girilen ihtiyaç taleplerinin listelenerek yardımseverlerin bu ihtiyaçları karşılayabilmesi amacıyla tasarlandı.

### Nasıl Çalışır?

- Depremzedeler veya Yardımseverler;
  - Telefon numarası ile sisteme kayıt olabilir.
  - Sistem tarafından girilen telefon numarasına sms gönderilir ve kullanıcıdan gelen sms’te yer alan kodu girmesi beklenir.
  - KVKK metni onaylaması beklenir.
- Depremzedeler,
  - İhtiyaç talebi oluşturabilir.
    - adres bilgi girişi
    - ihtiyaç bilgi girişi
    - iletişim cep telefonu bilgi girişi
    - iletişim yöntemi sadece sms veya hem sms hem whatsapp bilgi girişi
  - Oluşturdukları ihtiyaç taleplerini listeleyebilir.
  - Oluşturdukları ihtiyaç talebinin detayını görüntüleyebilir.
- Yardımseverler,
  - Depremzedelerin girdikleri talepleri listeleyebilir.
  - Depremzedelerin girdikleri talebin detayını görüntüleyebilir.
    - SMS veya Whatsapp ile iletişime geçebilir.

### Kullanım

- Uygulamayı indirin ve kurun.
- Üye olun veya mevcut hesabınızla giriş yapın.
- Depremzede iseniz, ihtiyaçlarınızı belirtin.
- Yardımsever iseniz, belirtilen ihtiyaçları görün ve yardım etmek istediğiniz ihtiyacı seçin.
- Yardımseverler, seçtikleri ihtiyaç sahibi ile iletişime geçerek yardımlarını gönderebilir.

### Katkıda bulunmak için

Bu uygulama açık kaynak kodlu ve geliştirmeye açık. Eğer katkıda bulunmak isterseniz, lütfen GitHub deposu ziyaret edin ve katkıda bulunun.

### Yayına alınan adresler

[Web Sitesi](https://afetdestek.org/#/)

### Genel Bilgilendirme ve Bağlantılar

- [Discord](https://discord.gg/itdepremyardim)
- [Tasarım (Figma)](https://www.figma.com/file/ggMF14osmhGOvKvS0VKuvQ/Yard%C4%B1m-A%C4%9F%C4%B1-App?node-id=0%3A1)
- Proje Sorumluları
  - PM: [@impinar](https://github.com/easeccy) impinar#4969
  - Flutter Architect & Co-Lead: [@easeccy](https://github.com/easeccy) Enes#7446
  - Co-Lead: [@erolkaftanoglu](https://github.com/erolkaftanoglu) Erol#9127
  - Maintainer: [@ndalyanlar](https://github.com/ndalyanlar)
  - Maintainer: [@adnanjpg](https://github.com/adnanjpg)
  - Maintainer: [@hberkayozdemir](https://github.com/hberkayozdemir)
  - Maintainer: [@bugragoksu](https://github.com/bugragoksu)
  - Maintainer: [@SeniorTurkmen](https://github.com/SeniorTurkmen)
- Github
  - [yardim-agi-flutter](https://github.com/acikkaynak/yardim-agi-flutter)
  - [yardim-agi-firebase](https://github.com/acikkaynak/yardim-agi-firebase)

### Kullanılan Teknoloji ve Sistemler

[![My Tech Stack](https://github-readme-tech-stack.vercel.app/api/cards?title=&borderRadius=0&fontSize=15&showBorder=false&lineCount=1&theme=github_dark&hideBg=true&hideTitle=true&line1=Flutter,Flutter,02569B;Firebase,Firebase,FFCA28;Firestore,Firestore,ffffff;)](https://github-readme-tech-stack.vercel.app/api/cards?title=&borderRadius=0&fontSize=15&showBorder=false&lineCount=1&theme=github_dark&hideBg=true&hideTitle=true&line1=Flutter,Flutter,02569B;Firebase,Firebase,FFCA28;Firestore,Firestore,ffffff;)

# Dev Guide
### İlk Çalıştırma

- get dependencies:
  
  ```bash
    # !/bin/bash
    flutter pub get
  ```
- generate files:
  
  ```bash
    # !/bin/bash
    flutter pub run build_runner build --delete-conflicting-outputs
  ```

- intl generator:

  ```bash
  # !/bin/bash
  flutter pub run easy_localization:generate -S assets/translations -f keys -O lib/gen/translations -o locale_keys.g.dart
  ```
### Style Guide
Uygulamamız `rtl` ve `ltr` dilleri destekledği için, kod içinde `left` veya `right` gibi özellikler kullanılmamalıdır. Bunun yerine `start` ve `end` kullanılmalıdır. `Flutter`'de `right` ve `left` özelliklerini içeren her `x` style biriminin `xDirectional` diye bir karşılığı vardır. 

#### Örnekler

##### EdgeInsets

önce:
```dart
EdgeInsets.only(left: 10)
```
sonra
```dart
EdgeInsetsDirectional.only(start: 10)
```

##### Alignment

önce:
```dart
Alignment.centerLeft
```

sonra:
```dart
AlignmentDirectional.centerStart
```

##### Border

önce:
```dart
Border(left: BorderSide(color: Colors.red))
```

sonra:
```dart
BorderDirectional(start: BorderSide(color: Colors.red))
```

##### Positioned

önce:
```dart
Positioned(left: 10, child: Container())
```

sonra:
```dart
PositionedDirectional(start: 10, child: Container())
```


