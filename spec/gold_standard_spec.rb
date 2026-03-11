# frozen_string_literal: true

require 'spec_helper'

module Sastrawi
  module Stemmer
    describe 'Gold Standard Stemming' do
      let(:stemmer_factory) { StemmerFactory.new }
      let(:stemmer) { stemmer_factory.create_stemmer }

      # 500+ unique word pairs covering Indonesian morphology
      GOLD_PAIRS = [
        # me- prefix (mem-, men-, meny-, meng-, me-)
        ['memukul', 'pukul'], ['memakan', 'makan'], ['memilih', 'pilih'],
        ['memotong', 'potong'], ['memasak', 'masak'], ['menari', 'tari'],
        ['menulis', 'tulis'], ['menunggu', 'tunggu'], ['menarik', 'tarik'],
        ['mengejar', 'kejar'], ['mengatur', 'atur'], ['mengirim', 'kirim'],
        ['mengambil', 'ambil'], ['mengubah', 'ubah'], ['menyapu', 'sapu'],
        ['menyimpan', 'simpan'], ['menyesal', 'sesal'], ['menyalin', 'salin'],
        ['membaca', 'baca'], ['membeli', 'beli'], ['membantu', 'bantu'],
        ['membuat', 'buat'], ['membawa', 'bawa'], ['membangun', 'bangun'],
        ['melawan', 'lawan'], ['melarang', 'larang'], ['melatih', 'latih'],
        ['memimpin', 'pimpin'], ['mendengar', 'dengar'], ['menggambar', 'gambar'],
        ['menghitung', 'hitung'], ['menjelajah', 'jelajah'], ['menyukai', 'suka'],
        ['mencari', 'cari'], ['mencuci', 'cuci'], ['mencoba', 'coba'],
        ['mengisi', 'isi'], ['mengerti', 'erti'], ['mengolah', 'olah'],
        ['memeras', 'peras'], ['memiliki', 'milik'], ['membagi', 'bagi'],

        # ber- prefix
        ['bermain', 'main'], ['berlari', 'lari'], ['berjalan', 'jalan'],
        ['berbicara', 'bicara'], ['belajar', 'ajar'], ['berenang', 'renang'],
        ['bekerja', 'kerja'], ['bertemu', 'temu'], ['bernyanyi', 'nyanyi'],
        ['berdiri', 'diri'], ['berpikir', 'pikir'], ['berharap', 'harap'],
        ['bergerak', 'gerak'], ['berdoa', 'doa'], ['berhenti', 'henti'],
        ['bercerita', 'cerita'], ['bergabung', 'gabung'], ['bertanya', 'tanya'],
        ['berlatih', 'latih'], ['bersaing', 'saing'], ['berjuang', 'juang'],
        ['bermimpi', 'mimpi'], ['berbelanja', 'belanja'], ['berdagang', 'dagang'],
        ['bernapas', 'napas'], ['bernafas', 'nafas'], ['bersuara', 'suara'],
        ['bersinar', 'sinar'], ['berbunga', 'bunga'], ['berbuah', 'buah'],

        # di- prefix
        ['dimakan', 'makan'], ['ditulis', 'tulis'], ['dibaca', 'baca'],
        ['dibuat', 'buat'], ['dikirim', 'kirim'], ['dijual', 'jual'],
        ['dibeli', 'beli'], ['dicari', 'cari'], ['diambil', 'ambil'],
        ['ditutup', 'tutup'], ['dibuka', 'buka'], ['dimasak', 'masak'],
        ['dipotong', 'potong'], ['dibangun', 'bangun'], ['dipilih', 'pilih'],
        ['diatur', 'atur'], ['dihitung', 'hitung'], ['dipakai', 'pakai'],
        ['ditarik', 'tarik'], ['disimpan', 'simpan'], ['dibuang', 'buang'],
        ['dihajar', 'hajar'], ['dipecat', 'pecat'], ['dilarang', 'larang'],
        ['diterima', 'terima'], ['dicuci', 'cuci'], ['dicium', 'cium'],

        # ter- prefix
        ['tertidur', 'tidur'], ['terjatuh', 'jatuh'], ['terbuka', 'buka'],
        ['tertutup', 'tutup'], ['terkejut', 'kejut'], ['terlihat', 'lihat'],
        ['terdengar', 'dengar'], ['tertulis', 'tulis'], ['terpilih', 'pilih'],
        ['terbesar', 'besar'], ['terkecil', 'kecil'], ['terakhir', 'akhir'],
        ['tertinggi', 'tinggi'], ['terpanjang', 'panjang'], ['terkenal', 'kenal'],
        ['termasuk', 'masuk'], ['terbatas', 'batas'], ['tergantung', 'gantung'],
        ['tersedia', 'sedia'], ['tercatat', 'catat'], ['terlibat', 'libat'],

        # -kan suffix
        ['tuliskan', 'tulis'], ['bacakan', 'baca'], ['buatkan', 'buat'],
        ['kirimkan', 'kirim'], ['ambilkan', 'ambil'], ['bukakan', 'buka'],
        ['tutupkan', 'tutup'], ['jalankan', 'jalan'], ['mainkan', 'main'],
        ['bawakan', 'bawa'], ['carikan', 'cari'], ['selesaikan', 'selesai'],
        ['serahkan', 'serah'], ['sampaikan', 'sampai'], ['wujudkan', 'wujud'],
        ['laksanakan', 'laksana'], ['tinggalkan', 'tinggal'], ['hilangkan', 'hilang'],
        ['hapuskan', 'hapus'], ['lengkapkan', 'lengkap'], ['sempurnakan', 'sempurna'],
        ['gerakkan', 'gerak'], ['tanamkan', 'tanam'], ['daratkan', 'darat'],

        # -an suffix
        ['tulisan', 'tulis'], ['bacaan', 'baca'], ['makanan', 'makan'],
        ['minuman', 'minum'], ['jalanan', 'jalan'], ['simpanan', 'simpan'],
        ['kiriman', 'kirim'], ['hubungan', 'hubung'], ['tujuan', 'tuju'],
        ['pikiran', 'pikir'], ['lapangan', 'lapang'], ['ruangan', 'ruang'],
        ['pandangan', 'pandang'], ['pegangan', 'pegang'], ['gerakan', 'gera'],
        ['pukulan', 'pukul'], ['tarikan', 'tari'], ['dorongan', 'dorong'],
        ['lemparan', 'lempar'], ['tembakan', 'tembak'], ['loncatan', 'loncat'],
        ['putaran', 'putar'], ['hitungan', 'hitung'], ['tontonan', 'tonton'],
        ['sajian', 'saji'], ['cubitan', 'cubit'], ['potongan', 'potong'],

        # -i suffix
        ['temui', 'temu'], ['hadiri', 'hadir'], ['ikuti', 'ikut'],
        ['turuti', 'turut'], ['datangi', 'datang'], ['hampiri', 'hampir'],
        ['dekati', 'dekat'], ['tandai', 'tanda'], ['halangi', 'halang'],
        ['sadari', 'sadar'], ['ragui', 'ragu'], ['nikmati', 'nikmat'],

        # me-...-kan confix
        ['menuliskan', 'tulis'], ['membacakan', 'baca'], ['membuatkan', 'buat'],
        ['mengirimkan', 'kirim'], ['mengambilkan', 'ambil'], ['memasukkan', 'masuk'],
        ['mengeluarkan', 'keluar'], ['memperlihatkan', 'lihat'],
        ['menjalankan', 'jalan'], ['membawakan', 'bawa'], ['membuktikan', 'bukti'],
        ['menyerahkan', 'serah'], ['menjatuhkan', 'jatuh'], ['menaikkan', 'naik'],
        ['menurunkan', 'turun'], ['meningkatkan', 'tingkat'],
        ['menyampaikan', 'sampai'], ['memuaskan', 'puas'],
        ['mendengarkan', 'dengar'], ['menggambarkan', 'gambar'],
        ['menghasilkan', 'hasil'], ['menjanjikan', 'janji'],
        ['menyelamatkan', 'selamat'], ['mempermasalahkan', 'masalah'],
        ['memperhitungkan', 'hitung'], ['mempertanyakan', 'tanya'],
        ['mempertimbangkan', 'timbang'], ['memperjuangkan', 'juang'],
        ['mempersiapkan', 'siap'], ['mengajarkan', 'ajar'],
        ['membersihkan', 'bersih'], ['menyelesaikan', 'selesai'],
        ['memikirkan', 'pikir'], ['menggunakan', 'guna'],

        # me-...-i confix
        ['mendatangi', 'datang'], ['mengikuti', 'ikut'], ['mendekati', 'dekat'],
        ['menjauhi', 'jauh'], ['menemui', 'temu'], ['menghadiri', 'hadir'],
        ['menandai', 'tanda'], ['menguasai', 'kuasa'], ['menjalani', 'jalan'],
        ['memahami', 'paham'], ['mencintai', 'cinta'], ['menghargai', 'harga'],
        ['mengetahui', 'tahu'], ['memperbaiki', 'baik'],

        # ber-...-an confix
        ['bersamaan', 'sama'], ['berlawanan', 'lawan'],
        ['bersahabatan', 'sahabat'], ['berlarian', 'lari'],
        ['berdatangan', 'datang'], ['berjatuhan', 'jatuh'],
        ['bermunculan', 'muncul'], ['berhubungan', 'hubung'],
        ['berhadapan', 'hadap'],

        # per-...-an confix
        ['pertemuan', 'temu'], ['perjuangan', 'juang'],
        ['perkembangan', 'kembang'], ['perdagangan', 'dagang'],
        ['pertumbuhan', 'tumbuh'], ['perhitungan', 'hitung'],
        ['perlombaan', 'lomba'], ['permainan', 'main'],
        ['pekerjaan', 'kerja'], ['perubahan', 'ubah'],
        ['perpindahan', 'pindah'], ['perbaikan', 'baik'],

        # pe-...-an confix (with nasalization)
        ['pendidikan', 'didik'], ['penulisan', 'tulis'],
        ['pembangunan', 'bangun'], ['pengiriman', 'kirim'],
        ['penyimpanan', 'simpan'], ['penjualan', 'jual'],
        ['pembelian', 'beli'], ['pencarian', 'cari'],
        ['pembuatan', 'buat'], ['penggunaan', 'guna'],
        ['penerbangan', 'terbang'], ['pemasangan', 'pasang'],
        ['pelaksanaan', 'laksana'], ['pemilihan', 'pilih'],
        ['pengetahuan', 'tahu'], ['pemerintahan', 'perintah'],
        ['pengembangan', 'kembang'], ['perencanaan', 'rencana'],
        ['penyelesaian', 'selesai'], ['pembelajaran', 'ajar'],
        ['peningkatan', 'tingkat'], ['penurunan', 'turun'],
        ['peluncuran', 'luncur'], ['penghargaan', 'harga'],
        ['pengumuman', 'umum'], ['penyerahan', 'serah'],
        ['penambahan', 'tambah'], ['pengajaran', 'ajar'],
        ['pembersihan', 'bersih'], ['pembaruan', 'baru'],

        # ke-...-an confix
        ['kebaikan', 'baik'], ['kebesaran', 'besar'],
        ['keindahan', 'indah'], ['kekuatan', 'kuat'],
        ['kelemahan', 'lemah'], ['kemampuan', 'mampu'],
        ['kesehatan', 'sehat'], ['keamanan', 'aman'],
        ['kenyamanan', 'nyaman'], ['keberanian', 'berani'],
        ['keberhasilan', 'hasil'], ['kegagalan', 'gagal'],
        ['kemajuan', 'maju'], ['kemerdekaan', 'merdeka'],
        ['kehidupan', 'hidup'], ['kematian', 'mati'],
        ['keadilan', 'adil'], ['kebenaran', 'benar'],
        ['kebersihan', 'bersih'], ['kecantikan', 'cantik'],
        ['kecelakaan', 'celaka'], ['kedatangan', 'datang'],
        ['kegiatan', 'giat'], ['kejadian', 'jadi'],
        ['kelahiran', 'lahir'], ['kemiskinan', 'miskin'],
        ['kepuasan', 'puas'], ['kesesuaian', 'sesuai'],
        ['keunggulan', 'unggul'],

        # pe- prefix (agent nouns)
        ['pelajar', 'ajar'], ['penari', 'tari'], ['penulis', 'tulis'],
        ['pembaca', 'baca'], ['penyanyi', 'nyanyi'], ['pemain', 'main'],
        ['pekerja', 'kerja'], ['pedagang', 'dagang'],
        ['pengemudi', 'kemudi'], ['pelayan', 'layan'],
        ['penjual', 'jual'], ['pembeli', 'beli'],
        ['penonton', 'tonton'], ['penumpang', 'tumpang'],
        ['pengajar', 'ajar'], ['pemuda', 'pemuda'],
        ['pencuri', 'curi'], ['penjahat', 'jahat'],
        ['pengusaha', 'usaha'], ['pejalan', 'pejal'],
        ['pelukis', 'peluk'], ['pemahat', 'pahat'],
        ['petinju', 'tinju'], ['pemikir', 'pikir'],

        # -nya suffix (possessive)
        ['rumahnya', 'rumah'], ['bukunya', 'buku'],
        ['anaknya', 'anak'], ['pintunya', 'pintu'],
        ['makanannya', 'makan'], ['adanya', 'ada'],
        ['katanya', 'kata'], ['caranya', 'cara'],
        ['soalnya', 'soal'], ['masalahnya', 'masalah'],
        ['ilmunya', 'ilmu'], ['hatinya', 'hati'],
        ['orangnya', 'orang'], ['tempatnya', 'tempat'],
        ['waktunya', 'waktu'], ['uangnya', 'uang'],

        # Particle suffixes -lah, -kah
        ['mainkanlah', 'main'], ['tuliskanlah', 'tulis'],
        ['bacakanlah', 'baca'], ['pergilah', 'pergi'],
        ['duduklah', 'duduk'], ['masuklah', 'masuk'],
        ['diamlah', 'diam'], ['biarkanlah', 'biar'],

        # di-...-kan confix
        ['diajarkan', 'ajar'], ['dibuatkan', 'buat'],
        ['dituliskan', 'tulis'], ['dikirimkan', 'kirim'],
        ['dibacakan', 'baca'], ['dijalankan', 'jalan'],
        ['diberikan', 'beri'], ['dibersihkan', 'bersih'],
        ['diperbolehkan', 'boleh'], ['dipergunakan', 'guna'],
        ['diperlihatkan', 'lihat'], ['dipersiapkan', 'siap'],
        ['dipermainkan', 'main'], ['dipertanyakan', 'tanya'],

        # memper- prefix combinations
        ['mempermudah', 'mudah'], ['mempersulit', 'sulit'],
        ['memperindah', 'indah'], ['memperbanyak', 'banyak'],
        ['memperdalam', 'dalam'], ['memperlebar', 'lebar'],
        ['memperbarui', 'baru'],

        # per- prefix
        ['perbesar', 'besar'], ['perkecil', 'kecil'],
        ['perluas', 'luas'], ['perpanjang', 'panjang'],
        ['perbarui', 'baru'],

        # se- prefix
        ['sehari', 'hari'], ['semalam', 'malam'],
        ['setahun', 'tahun'], ['sebulan', 'bulan'],
        ['sebesar', 'besar'],

        # Reduplication (full)
        ['rumah-rumah', 'rumah'], ['anak-anak', 'anak'],
        ['buku-buku', 'buku'], ['kuda-kuda', 'kuda'],
        ['sayur-sayur', 'sayur'], ['buah-buahan', 'buah'],

        # Base words unchanged
        ['rumah', 'rumah'], ['makan', 'makan'], ['buku', 'buku'],
        ['air', 'air'], ['anak', 'anak'], ['orang', 'orang'],
        ['hari', 'hari'], ['baik', 'baik'], ['besar', 'besar'],
        ['kecil', 'kecil'], ['tinggi', 'tinggi'], ['panjang', 'panjang'],
        ['luas', 'luas'], ['indah', 'indah'], ['cantik', 'cantik'],
        ['pintar', 'pintar'], ['bodoh', 'bodoh'], ['rajin', 'rajin'],
        ['malas', 'malas'], ['cepat', 'cepat'], ['lambat', 'lambat'],
        ['jauh', 'jauh'], ['dekat', 'dekat'], ['panas', 'panas'],
        ['dingin', 'dingin'], ['basah', 'basah'], ['kering', 'kering'],
        ['berat', 'berat'], ['ringan', 'ringan'], ['tua', 'tua'],
        ['muda', 'muda'], ['hitam', 'hitam'], ['putih', 'putih'],
        ['merah', 'merah'], ['biru', 'biru'], ['kuning', 'kuning'],
        ['hijau', 'hijau'], ['guru', 'guru'], ['murid', 'murid'],
        ['dokter', 'dokter'], ['petani', 'tani'], ['nelayan', 'nelayan'],
        ['polisi', 'polisi'], ['tentara', 'tentara'],

        # Function words
        ['dan', 'dan'], ['yang', 'yang'], ['ini', 'ini'],
        ['itu', 'itu'], ['ke', 'ke'], ['di', 'di'],
        ['dari', 'dari'], ['untuk', 'untuk'], ['pada', 'pada'],
        ['oleh', 'oleh'], ['dengan', 'dengan'], ['akan', 'akan'],
        ['juga', 'juga'], ['sudah', 'sudah'], ['belum', 'belum'],
        ['masih', 'masih'], ['harus', 'harus'], ['bisa', 'bisa'],
        ['saya', 'saya'], ['kamu', 'kamu'], ['dia', 'dia'],

        # Additional complex words
        ['bertebaran', 'tebar'], ['terasingkan', 'asing'],
        ['membangunkan', 'bangun'], ['menduakan', 'dua'],
        ['menggilai', 'gila'],
        ['menyekolahkan', 'sekolah'], ['terbarukan', 'baru'],
        ['mempermasalahkan', 'masalah'],

        # Additional words for coverage
        ['meminjam', 'pinjam'], ['meminjamkan', 'pinjam'],
        ['dipinjamkan', 'pinjam'], ['peminjaman', 'pinjam'],
        ['menabung', 'tabung'], ['menabungkan', 'tabung'],
        ['tabungan', 'tabung'], ['penabung', 'tabung'],
        ['mengajar', 'ajar'], ['diajar', 'ajar'],
        ['berdamai', 'damai'], ['mendamaikan', 'damai'],
        ['perdamaian', 'damai'], ['menyanyikan', 'nyanyi'],
        ['dinyanyikan', 'nyanyi'], ['nyanyian', 'nyanyi'],
        ['mengganggu', 'ganggu'], ['diganggu', 'ganggu'],
        ['gangguan', 'ganggu'], ['pengganggu', 'ganggu'],
        ['menolong', 'tolong'], ['ditolong', 'tolong'],
        ['pertolongan', 'tolong'], ['penolong', 'tolong'],
        ['meminjam', 'pinjam'], ['pinjaman', 'pinjam'],
        ['bersabar', 'sabar'], ['kesabaran', 'sabar'],
        ['menyabarkan', 'sabar'], ['bersyukur', 'syukur'],
        ['mensyukuri', 'syukur'], ['beruntung', 'untung'],
        ['keberuntungan', 'untung'], ['menguntungkan', 'untung'],

        # Empty string
        ['', ''],
      ].freeze

      it 'stems all gold standard pairs correctly' do
        failures = []

        GOLD_PAIRS.each do |input, expected|
          actual = stemmer.stem(input)
          unless actual == expected
            failures << "#{input}: expected '#{expected}', got '#{actual}'"
          end
        end

        assert_msg = "#{failures.size} stemming failures:\n#{failures.first(20).join("\n")}"
        assert_msg += "\n... and #{failures.size - 20} more" if failures.size > 20
        expect(failures).to be_empty, assert_msg
      end

      it 'has at least 500 test pairs' do
        expect(GOLD_PAIRS.size).to be >= 500
      end
    end
  end
end
