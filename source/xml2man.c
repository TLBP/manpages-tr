/*
 Copyright ©  2007  Nilgün Belma Bugüner <nilgun@belgeler·org>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
*/


  /* Bu dosyada uzun uzadıya hatalar elde edilmeye çalışılmamıştır.
   * XML dosyaları man dosyalarına dönüştürürken, tali
   * uygulamalarla elde edilemeyen bazı özel durumları elde edebilmek
   * amacıyla bu kod geliştirilmiştir.
   * Bu bir kullanıcı uygulaması değildir.
   * Lütfen komut satırını doğru yazın ve amacı dışında kullanmayın...
   */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <locale.h>
#include <string.h>
#include <signal.h>
#include <zlib.h>

static const struct table_tags {
  char *start;
  char *end;
  int lenso;
  int leneo;
} tags [] = {
       { 0 },
       { "<literallayout", "</literallayout>", 14, 16 },
       { "<programlisting", "</programlisting>", 15, 17 },
       { "<screen", "</screen>", 7, 9 },
       { "<synopsis", "</synopsis>", 8, 10 },
       { "<remark", "</remark>", 6, 8 },
       { 0 }
};

static const struct table_xslss {
  char *str;
} xslss [] = {
  { "<?xml version='1.0' encoding=\"UTF-8\"?>\n<?xml-stylesheet type=\"text/xsl\" href=\"#xslss\"?> <!DOCTYPE reference [ <!ATTLIST xsl:stylesheet id ID #IMPLIED> ]><reference><xsl:stylesheet id=\"xslss\"  version='1.0' xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"><xsl:include href=\"xml2man.xsl\"/><xsl:include href=\"xml2man-doc.xsl\"/><xsl:output method=\"text\" encoding=\"UTF-8\" omit-xml-declaration=\"yes\" standalone=\"yes\" indent=\"no\"/><xsl:template match=\"reference\"><xsl:apply-templates/></xsl:template><xsl:template match=\"xsl:stylesheet\"/></xsl:stylesheet>" },
  { "</reference> \n\n" },
  { 0 }
};

static const struct table_s {
  char *groff;
  char *xml;
} table [] = {
  { "-", "-" },
  { "-", "−" },
  { "-", "–" },
  { "N'39'", "'" },
  { "N'39'", "´" },
  { "N'39'", "’" },
  { "N'96'", "`" },
  { "N'96'", "‘" },
  { "N'34'", "“" },
  { "N'34'", "”" },
  { " ", " " },          /* nobreakspace */
  { "(bu", "•" },
  { "N'45'", "-" },
  { "N'45'", "−" },
  { "N'45'", "–" },
  { "(r!", "¡" },
  { "(ct", "¢" },
  { "(Po", "£" },
  { "(Cs", "&#x00A4;" },
  { "(Ye", "¥" },
  { "(bb", "¦" },
  { "(sc", "§" },
  { "(ad", "&#x00A8;" },
  { "(co", "©" },
  { "(Of", "&#x00AA;" },
  { "(Fo", "«" },
  { "(no", "&#x00AC;" },
  { "[shc]", "&#x00AD;" },
  { "(rg", "®" },
  { "(a-", "&#x00AF;" },
  { "(de", "°" },
  { "(+-", "±" },
  { "(S2", "²" },
  { "(S3", "³" },
  { "[char181]", "µ" },
  { "(ps", "¶" },
  { "(pc", "&#x00B7;" },
  { "(ac", "&#x00B8;" },
  { "(S1", "¹" },
  { "(Om", "&#x00BA;" },
  { "(Fc", "»" },
  { "(14", "¼" },
  { "(12", "½" },
  { "(34", "¾" },
  { "(r?", "¿" },
  { "(`A", "&#x00C0;" },
  { "('A", "&#x00C1;" },
  { "(^A", "Â" },
  { "(~A", "&#x00C3;" },
  { "(:A", "&#x00C4;" },
  { "(oA", "&#x00C5;" },
  { "(AE", "&#x00C6;" },
  { "(,C", "Ç" },
  { "(`E", "&#x00C8;" },
  { "('E", "&#x00C9;" },
  { "(^E", "&#x00CA;" },
  { "(:E", "&#x00CB;" },
  { "(`I", "&#x00CC;" },
  { "('I", "&#x00CD;" },
  { "(^I", "Î" },
  { "(:I", "&#x00CF;" },
  { "(-D", "&#x00D0;" },
  { "(~N", "&#x00D1;" },
  { "(`O", "&#x00D2;" },
  { "('O", "&#x00D3;" },
  { "(^O", "Ô" },
  { "(~O", "&#x00D5;" },
  { "(:O", "Ö" },
  { "(mu", "&#x00D7;" },
  { "(/O", "&#x00D8;" },
  { "(`U", "&#x00D9;" },
  { "('U", "&#x00DA;" },
  { "(^U", "Û" },
  { "(:U", "Ü" },
  { "('Y", "&#x00DD;" },
  { "(TP", "&#x00DE;" },
  { "(ss", "&#x00DF;" },
  { "(`a", "&#x00E0;" },
  { "('a", "&#x00E1;" },
  { "(^a", "â" },
  { "(~a", "&#x00E3;" },
  { "(:a", "&#x00E4;" },
  { "(oa", "&#x00E5;" },
  { "(ae", "&#x00E6;" },
  { "(,c", "ç" },
  { "(`e", "&#x00E8;" },
  { "('e", "&#x00E9;" },
  { "(^e", "&#x00EA;" },
  { "(:e", "&#x00EB;" },
  { "(`i", "&#x00EC;" },
  { "('i", "&#x00ED;" },
  { "(^i", "î" },
  { "(:i", "&#x00EF;" },
  { "(Sd", "&#x00F0;" },
  { "(~n", "&#x00F1;" },
  { "(`o", "&#x00F2;" },
  { "('o", "&#x00F3;" },
  { "(^o", "ô" },
  { "(~o", "&#x00F5;" },
  { "(:o", "ö" },
  { "(di", "&#x00F7;" },
  { "(/o", "&#x00F8;" },
  { "(`u", "&#x00F9;" },
  { "('u", "&#x00FA;" },
  { "(^u", "û" },
  { "(:u", "ü" },
  { "('y", "&#x00FD;" },
  { "(Tp", "&#x00FE;" },
  { "(:y", "&#x00FF;" },
  { "[u0047_0306]", "Ğ" },
  { "[u0067_0306]", "ğ" },
  { "[u0073_0327]", "ş" },
  { "[u0053_0327]", "Ş" },
  { "[u0049_0307]", "İ" },
  { "(.i", "ı" },
  { "(/L", "&#x0141;" },
  { "(/l", "&#x0142;" },
  { "(OE", "&#x0152;" },
  { "(oe", "&#x0153;" },
  { "(Fn", "&#x0192;" },
  { "(ah", "&#x02C7;" },
  { "(ab", "&#x02D8;" },
  { "(a.", "&#x02D9;" },
  { "(ao", "&#x02DA;" },
  { "(ho", "&#x02DB;" },
  { "(a\"", "&#x02DD;" },
  { "(*A", "&#x0391;" },
  { "(*B", "&#x0392;" },
  { "(*G", "&#x0393;" },
  { "(*D", "&#x0394;" },
  { "(*E", "&#x0395;" },
  { "(*Z", "&#x0396;" },
  { "(*Y", "&#x0397;" },
  { "(*H", "&#x0398;" },
  { "(*I", "&#x0399;" },
  { "(*K", "&#x039A;" },
  { "(*L", "&#x039B;" },
  { "(*M", "&#x039C;" },
  { "(*N", "&#x039D;" },
  { "(*C", "&#x039E;" },
  { "(*O", "&#x039F;" },
  { "(*P", "&#x03A0;" },
  { "(*R", "&#x03A1;" },
  { "(*S", "&#x03A3;" },
  { "(*T", "&#x03A4;" },
  { "(*U", "&#x03A5;" },
  { "(*F", "&#x03A6;" },
  { "(*X", "&#x03A7;" },
  { "(*Q", "&#x03A8;" },
  { "(*W", "&#x03A9;" },
  { "(*a", "&#x03B1;" },
  { "(*b", "&#x03B2;" },
  { "(*g", "&#x03B3;" },
  { "(*d", "&#x03B4;" },
  { "(*e", "&#x03B5;" },
  { "(*z", "&#x03B6;" },
  { "(*y", "&#x03B7;" },
  { "(*h", "&#x03B8;" },
  { "(*i", "&#x03B9;" },
  { "(*k", "&#x03BA;" },
  { "(*l", "&#x03BB;" },
  { "(*m", "&#x03BC;" },
  { "(*n", "&#x03BD;" },
  { "(*c", "&#x03BE;" },
  { "(*o", "&#x03BF;" },
  { "(*p", "&#x03C0;" },
  { "(*r", "&#x03C1;" },
  { "(ts", "&#x03C2;" },
  { "(*s", "&#x03C3;" },
  { "(*t", "&#x03C4;" },
  { "(*u", "&#x03C5;" },
  { "(*f", "&#x03C6;" },
  { "(*x", "&#x03C7;" },
  { "(*q", "&#x03C8;" },
  { "(*w", "&#x03C9;" },
  { "(+h", "&#x03D1;" },
  { "(+f", "&#x03D5;" },
  { "(+p", "&#x03D6;" },
  { "(hy", "&#x2010;" },
  { "(en", "⁃" },
  { "(em", "&#x2014;" },
  { "(oq", "&#x2018;" },
  { "(cq", "&#x2019;" },
  { "(bq", "&#x201A;" },
  { "(lq", "&#x201C;" },
  { "(rq", "&#x201D;" },
  { "(Bq", "&#x201E;" },
  { "(dg", "&#x2020;" },
  { "(dd", "&#x2021;" },
  { "(%0", "&#x2030;" },
  { "(fm", "&#x2032;" },
  { "(sd", "&#x2033;" },
  { "(fo", "&#x2039;" },
  { "(fc", "&#x203A;" },
  { "(rn", "&#x203E;" },
  { "(f/", "&#x2044;" },
  { "(Im", "&#x2111;" },
  { "(wp", "&#x2118;" },
  { "(Re", "&#x211C;" },
  { "(tm", "&#x2122;" },
  { "(Ah", "&#x2135;" },
  { "(<-", "&#x2190;" },
  { "(ua", "&#x2191;" },
  { "(->", "&#x2192;" },
  { "(da", "&#x2193;" },
  { "(<>", "&#x2194;" },
  { "(lA", "&#x21D0;" },
  { "(uA", "&#x21D1;" },
  { "(rA", "&#x21D2;" },
  { "(dA", "&#x21D3;" },
  { "(hA", "&#x21D4;" },
  { "(fa", "&#x2200;" },
  { "(pd", "&#x2202;" },
  { "(te", "&#x2203;" },
  { "(es", "&#x2205;" },
  { "(gr", "&#x2207;" },
  { "(mo", "&#x2208;" },
  { "(nm", "&#x2209;" },
  { "(st", "&#x220B;" },
  { "(\\-", "&#x2212;" },
  { "(mi", "&#x2212;" },
  { "(**", "&#x2217;" },
  { "(sr", "&#x221A;" },
  { "(pt", "&#x221D;" },
  { "(if", "&#x221E;" },
  { "(/_", "&#x2220;" },
  { "(AN", "&#x2227;" },
  { "(OR", "&#x2228;" },
  { "(ca", "&#x2229;" },
  { "(cu", "&#x222A;" },
  { "(is", "&#x222B;" },
  { "(tf", "&#x2234;" },
  { "(ti", "&#x223C;" },
  { "(ap", "&#x223C;" },
  { "(=~", "&#x2245;" },
  { "(~~", "&#x2248;" },
  { "(~=", "&#x2248;" },
  { "(!=", "&#x2260;" },
  { "(==", "&#x2261;" },
  { "(<=", "&#x2264;" },
  { "(>=", "&#x2265;" },
  { "(sb", "&#x2282;" },
  { "(sp", "&#x2283;" },
  { "(ib", "&#x2286;" },
  { "(ip", "&#x2287;" },
  { "(c+", "&#x2295;" },
  { "(c*", "&#x2297;" },
  { "(pp", "&#x22A5;" },
  { "(pc", "&#x22C5;" },
  { "(lc", "&#x2308;" },
  { "(rc", "&#x2309;" },
  { "(lf", "&#x230A;" },
  { "(rf", "&#x230B;" },
  { "(la", "&#x2329;" },
  { "(ra", "&#x232A;" },
  { "(CR", "&#x240D;" },
  { "(an", "&#x2500;" },
  { "(rk", "&#x251D;" },
  { "(lk", "&#x2525;" },
  { "(lt", "&#x256D;" },
  { "(rt", "&#x256E;" },
  { "(rb", "&#x256F;" },
  { "(lb", "&#x2570;" },
  { "(sq", "&#x25A1;" },
  { "(lz", "&#x25CA;" },
  { "(ci", "&#x25EF;" },
  { "(lh", "&#x261C;" },
  { "(rh", "&#x261E;" },
  { "(ff", "&#xFB00;" },
  { "(fi", "&#xFB01;" },
  { "(fl", "&#xFB02;" },
  { "(Fi", "&#xFB03;" },
  { "(Fl", "&#xFB04;" },
  { NULL, NULL }
};
char *sostr;

void *
xmalloc (size_t size)
{
  register void *value = malloc (size);
  if (value == 0) {
    fprintf (stderr, "xmalloc: request for %u bytes failed.\n", size);
    abort ();
  }
  return value;
}

/* ========================================================= */
char *
load_file(const char *name)
{
  char *buffer;
  gzFile *f;
  int ret, size;

  f = gzopen(name, "r");
  if (!f) {
    fprintf(stderr, "xml2man:load_file: cannot open '%s'.\n", name);
    exit(1);
  }

  size = 32 * 1024;
  while (1) {
    buffer = alloca(size + 4);
    ret = gzread(f, buffer, size);
    if (ret == -1) {
      fprintf(stderr, "xml2man:load_file: read error in '%s'.\n", name);
      exit(1);
    }
    if (ret < size) break;
    //free(buffer);
    size *= 2;
    gzseek(f, 0, SEEK_SET);
  }
  gzclose(f);
  buffer[ret] = '\0';

  return buffer;
}
/* ================================================================= */
char *
prexslt (char *buffer)
{
  char *src, *tgt, *buf2, *t, *tmp;
  int len, i = 0, j, k, pos;

  len = strlen(buffer);
  if (buffer[len - 1] != '\n') {
    puts("Dosya düzgün sonlandırılmamış");
    exit(1);
  }

  t = strstr(buffer, "<refentry");
  if (!t) {
    puts("Dosya bir kılavuz sayfası içermiyor");
    exit(1);
  }

  for (src = buffer; *src; src++)
    if (*src == '\\') i++;

  for (src = buffer; *src; src++){
    k = 0;
    for (j = 1; j < 6; j++)
      if (strncmp(src, tags[j].start, tags[j].lenso) == 0) k = j;
    if (k) {
      while (1) {
        if (strncmp(src, "\n ", 2) == 0) i++;
        if (strncmp(src, tags[k].end, tags[k].leneo) == 0) break;
        ++src;
      }
    }
  }

  len = strlen(buffer) - (t - buffer);
  buf2 = xmalloc(len + i + 4);
  strncpy(buf2, t, len);
  buf2[len] = '\0';
  buffer = xmalloc(len + i + 4);
  memset (buffer, 0, len + i + 4);

  for (src = buf2, tgt = buffer; *src; src++, tgt++) {
    if (*src == '\\') {
      *tgt = *src;
      ++tgt;
      *tgt = *src;
    } else
      *tgt = *src;
  }

  memset (buf2, 0, len + i + 4);
  /* Boşlukları korunacak etiketlerin arasındakiler hariç
   * bütün satırsonu karakterlerini boşluklarla değiştireceğiz.
   */
  src = buffer;
  tgt = buf2;
  while (*src) {
    k = 0;
    for (i = 1; i < 6; i++)
      if (strncmp(src, tags[i].start, tags[i].lenso) == 0) k = i;
    if (k) {
      /* Burası boşlukların korunacağı yer */
      while (1) {
      /* Satır başlarındaki boşlukları özellikle korumaya almalıyız. */
        if (strncmp(src, "\n ", 2) == 0) {    /* linefeed + space */
          len = strlen(buffer) - (src - buffer) - 2;
          tmp = xmalloc (len);
          strncpy(tmp, src + 2, len);
          strncpy(src, "\n ", 3);     /* linefeed + nobreakspace */
          strncpy(src + 3, tmp, len);
          free(tmp);
        }
        /* Sonlandırıcı etikete rastlayınca bu bölgeyi olduğu gibi hedefe kopyalıyoruz. */
        if (strncmp(src, tags[k].end, tags[k].leneo) == 0) {
          strncpy(tgt, tags[k].end, tags[k].leneo);
          src += tags[k].lenso;
          tgt += tags[k].lenso;
          break;
        } else
          *tgt = *src;

        ++src; ++tgt;
      }
      /* Satırsonu karakterlerinin yerine boşluk koyuyoruz.
       * Böylece çıktıda oluşacak gereksiz boş satırlardan kurtuluyoruz.
       */
    } else if (*src == '\n')
        *tgt = ' ';
      else
        *tgt = *src;
    ++src; ++tgt;
  }
  strncpy(tgt, " \n\0", 3);

  /* Dosya xsltproc için hazır. Şimdi xslss içine alacağız ki,
   * xsltproc xslt betiklerimizi bulup derleme yapabilsin.
   */

  //puts(buf2);
  free(buffer);
  buffer = xmalloc (strlen(buf2) + 100000);
  memset (buffer, 0, strlen(buffer) + 100000);
  len = strlen(xslss[0].str);
  strncpy(buffer, xslss[0].str, len);
  pos = len; len = strlen(buf2);
  strncpy(buffer + pos, buf2, len);
  pos +=len; len = strlen(xslss[1].str);
  strncpy(buffer + pos, xslss[1].str, len);
  pos +=len;
  buffer[pos] = '\0';

  free(buf2);
  return buffer;
}
/* ================================================================= */
char *
apply_xslt(char *buffer)
{
  pid_t pid;
  int fdr[2], fdw[2];

  int i, k, len, pos, size = 32 * 1024;
  char **buf2;


  pipe(fdr);
  pipe(fdw);
  pid = fork();
  if (pid == -1) {
    puts("cannot fork()");
    exit(1);
  }

  if (pid == 0) {
    close(fdw[1]);
    close(fdr[0]);
    dup2(fdw[0], 0);
    dup2(fdr[1], 1);
    execlp("xsltproc", "xsltproc", "--stringparam", "sostr", sostr, "-", NULL);
    while(1);
  }
  close(fdw[0]);
  close(fdr[1]);
  write(fdw[1], buffer, strlen(buffer));
  write(fdw[1], "\n", 1);
  fsync(fdw[1]);
  close(fdw[1]);

  buf2 = xmalloc(32 * sizeof(char *));

  k = 0;
  while (1) {
    buf2[k] = xmalloc (size);
    len = read(fdr[0], buf2[k], size - 4);
    if (len == 0) {
      free(buf2[k]);
      buf2[k] = NULL;
      break;
    }
    if (len == -1) exit(4);
    buf2[k][len] = '\0';
    k++;
  }

  kill(pid, 9);

  len = 0;
  for (i = 0; i < k; i++)
    len += strlen(buf2[i]);

  free(buffer);
  buffer = xmalloc(len + 4);
  pos = 0;
  for (i = 0; i < k; i++) {
    len = strlen(buf2[i]);
    strncpy(buffer + pos, buf2[i], len);
    pos +=len;
    free(buf2[i]);
  }

  buffer[pos] = '\0';
  free(buf2);

  return buffer;
}
/* ================================================================= */
void
postxslt (char *buf, int nodeb)
{
  char *t;
  int h, i, j;
  int len, flag;

  if (nodeb) {
    h = 3;
    j = sizeof(table) / 8 - 1;
  } else {
    h = 0;
    j = 11;
  }
  
  for (t = buf; *t; t++) {
    flag = 0;
    for (i = h; i < j; i++) {
      len = strlen(table[i].xml);
      if (strncmp(table[i].xml, t, len) == 0) {
        printf("\\%s",table[i].groff);
        t += len - 1;
        flag = 1;
        break;
      }
    }
    if (flag == 0) {
    	if (strncmp("\n\n\n", t, 3) != 0)
    	    putchar(*t);
    }
//    if (flag == 0) putchar(*t);
  }
}

/* ================================================================= */
int
main(int argc, char *argv[])
{
  char *buf;

  setlocale (LC_ALL, "");

  if (argc < 2) {
    puts("usage: xml2man [ --debianize | --utf8 | --groff ] xml_file > man_file");
    return 1;
  }
  /* Bu dosyada uzun uzadıya hatalar elde edilmeye çalışılmamıştır.
   * XML dosyaları man dosyalarına dönüştürürken, tali
   * uygulamalarla elde edilemeyen bazı özel durumları elde edebilmek
   * amacıyla bu kod geliştirilmiştir.
   * Bu bir kullanıcı uygulaması değildir.
   * Lütfen komut satırını doğru yazın ve amacı dışında kullanmayın...
   */

  if (strncmp(argv[1], "--debianize", 11) != 0)
    sostr = ".so ";
  else
    sostr = "";

  buf = load_file(argv[argc - 1]);
  buf = prexslt(buf);
  buf = apply_xslt(buf);

  if (strncmp(argv[1], "--groff", 7) != 0)
    postxslt(buf, 0);
  else
    postxslt(buf, 1);

  //printf("%s %s: '%s'", argv[1], argv[2], sostr);

  return 0;
}
