### GNU/Linux Kılavuz Sayfaları Çeviri Çalışmaları

#### Tarihçe
Uzun süredir kılavuz sayfalarının çevrilmesi, Linux Belgelendirme Çalışma
Grubunun görevleri arasında yer almaktaydı. Ancak bu görev bir alt ekip
oluşturulmasını gerektirdiğinden Ekim 2003'de Yalçın Kolukısa "ben bu görevi
üstleniyorum" diyene kadar hayata geçirilememişti. İlk çevirileri de kendisi
yaptı. Bu arada Linux Belgelendirme Çalışma Grubu groff paketine türkçe
karakter desteği vermek için çalışmalara başladı. Groff ekibiyle yapılan
çalışma sonucunda bu destek sağlandı (Aralık 2003) ve böylece çeviri
çalışmaları sağlam bir temele oturtulmuş oldu.

Ekip lideri Yalçın Kolukısa'nın yaptığı çeviriler ve Linux Belgelendirme
Çalışma Grubunun alt yapı çalışmaları ile kılavuz sayfaları paket olarak
dağıtılmaya başlandı. Tanıtımlar sonucunda ekibimiz kısa sürede büyüdü ve
böyle bir bilgi sayfası ile bu amaca uygun bir iletişim listesi oluşturulması
ihtiyacı doğdu (Mart 2004).


#### Kılavuz Sayfası Nedir?

Kılavuz sayfaları (man pages) genellikle komut satırı uygulamalarının nasıl
kullanılacaklarını açıklayan yardım dosyalarıdır. Ancak yardım alanı sadece
komut satırı uygulamaları ile sınırlı değildir. Özel bir dosyanın biçimi,
belli bir kavramın açıklanması, kütüphane işlevlerinin açıklamaları gibi
oldukça geniş bir alanı kapsar.

Bu dosyaların çevirilerinin yapılmasındaki zorluk dosya biçiminden kaynaklanır.
Dosya biçimi çok çeşitli belge yazma dillerinin bir karışımıdır. Bu belge yazma
dillerinin özelliklerini bilmek ise ayrı bir uzmanlık alanıdır. Dolayısıyla, bu
dilleri bilmeden bu dosyaların metin kısmını koddan ayırdetmek çok zordur.
Ancak dosyanın konsoldaki dökümüne bakarak çevirmek kolaydır.

Biz de başta bu yolu tercih ettik. Kılavuz sayfasının ekran görüntüsünü kopyala
yapıştır yöntemiyle basitçe bir metin düzenleyicisine yapıştırıp çevrilmeye
hazır hale getiriyorduk.

Çeviri yapıldıktan sonra bu metni Docbook-XML'in kılavuz sayfaları yazmak için
kullanılan yapısıyla bu sayfaları işlenebilir duruma getiriyorduk. Şimdi,
artık önce groff dosyasını XML haline getirerek çeviriye hazır hale
getiriyoruz. Bundan sonrası dosya dönüşüm uygulamalarıyla çeviriyi istenen
dosya biçimlerine dönüştürmek oluyor. HTML'ye dönüştürüp belgeler.org.tr'de
yayınlıyoruz. Kılavuz sayfalarının biçimine dönüştürüp paket halinde
dağıtıyoruz.

Kılavuz sayfası biçimi artık dosyanın özgün kodlamasına benzemiyor olsa da
(biz özgün halinin hangi belge yazma dili ile yazıldığıyla ilgilenmiyoruz),
sonuç isteneni veriyor. Yani biz kılavuz sayfalarını hep aynı dil elemanları
ile üretiyoruz.


#### Çeviri ekibi nasıl çalışır?

GNU/Linux Kılavuz Sayfaları Çeviri Ekibi, Linux Belgelendirme Çalışma Grubunun
Kılavuz sayfaları çeviri projesini gerçekleştiren bir alt grubudur.

GNU/Linux Kılavuz Sayfaları Çeviri Ekibi gönüllülerden oluşur.

Ekibin üyesi olmak için en az bir çeviriyi üstlenmiş olmak yeterlidir.

Seçtiğiniz henüz çevirisi üstlenilmemiş bir dosyayı üstlendiğinizi
https://github.com/TLBP/source/issues adresinde "New Issue" düğmesine
tıklayıp yeni bir konu açarak herkesin bunu bilmesini sağlayın.

Çevrilecek kılavuz sayfasının XML dosyası en kısa zamanda
https://github.com/TLBP/source/tree/main/source/manpages altında ilgili dizine
yerleştirilecek ve size bilgi verilecektir. Depoyu çatallamak suretiyle,
depoyu makinenize indirerek veya dosya içeriğine kopyala yapıştır yaparak
dosyayı elde edebilirsiniz. Ancak çevirisi bitmiş dosyayı depoya teslim
etmek için PR yapmanız gerekeceğinden, depoyu çatallamanızı öneririz. Çok
sayıda çeviri yaparak bizi rahatsız etmeyi başarırsanız size doğrudan
depoya yazma izni de verebiliriz.
