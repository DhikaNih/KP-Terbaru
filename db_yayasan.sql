-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 12, 2026 at 09:02 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_yayasan`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id_admin`, `username`, `password`) VALUES
(1, 'admin', '$2y$10$Qj0rF9YqfW3QkNYQSVQ/NuLhMmP2hB7.dCsqgvl6W3FmjGphpmiJC');

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `kode_buku` varchar(20) NOT NULL,
  `judul_buku` varchar(255) NOT NULL,
  `penulis` varchar(100) DEFAULT NULL,
  `jumlah_lembar` int(11) DEFAULT 0,
  `volume` int(11) DEFAULT 0,
  `kode_ukuran` varchar(5) DEFAULT NULL,
  `ukuran_buku` varchar(50) DEFAULT NULL,
  `tahun_terbit` year(4) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT 0.00,
  `tgl_input` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `kode_buku`, `judul_buku`, `penulis`, `jumlah_lembar`, `volume`, `kode_ukuran`, `ukuran_buku`, `tahun_terbit`, `harga`, `tgl_input`) VALUES
(1, '-', 'AL QUR\'AN + TERJEMAH (STANDAR)', 'Tidak Ada', 1553, 30, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(2, '-', 'AL QUR\'AN TANPA TERJEMAH (TADARUS)', 'Tidak Ada', 1145, 30, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(3, '-', 'Al-Qur\'an 3 in 1', 'Tidak Ada', 620, 10, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(4, '-', 'Al-Qur\'an 2 in 1', 'Tidak Ada', 0, 0, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(5, '-', '7 SURAT PILIHAN + TERJEMAH (AL KAHFI, AS SAJDAH, YASIN, AL DUKHON, AL RAHMAN, AL WAQIAH, AL MULK)', 'TIM PENYUSUN BUKU YARFIN', 76, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(6, '-', '7 SURAT PILIHAN (TANPA TERJEMAH) (AL KAHFI, AS SAJDAH, YASIN, AL DUKHON, AL RAHMAN, AL WAQIAH, AL MULK)', 'TIM PENYUSUN BUKU YARFIN', 32, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(7, '-', '7 SURAT PILIHAN (BUKU KECIL) (AL KAHFI, AS SAJDAH, YASIN, AL DUKHON, AL RAHMAN, AL WAQIAH, AL MULK)', 'TIM PENYUSUN BUKU YARFIN', 58, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(8, '-', '7 SURAT PILIHAN +BACAAN ZIKIR, TAHLIL DAN DOA + ASMAUL HUSNA (TANPA TERJEMAH)', 'TIM PENYUSUN BUKU YARFIN', 40, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(9, '-', '8 SURAT PILIHAN TANPA TERJEMAH (AL BAQARAH, AL KAHFI, AS SAJDAH, YASIN, AL DUKHON, AL RAHMAN, AL WAQIAH, AL MULK)', 'TIM PENYUSUN BUKU YARFIN', 69, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(10, '-', '11 SURAT PILIHAN (YUSUF, KAHFI, MARYAM, LUKMAN, AS SAJDAH, YASIN, AD DUKHAN, AR RAHMAN, AL WAQIAH, AL HASYR, AL MULK)', 'TIM PENYUSUN BUKU YARFIN', 58, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(11, '-', '150 HADITS PILIHAN UNTUK PEMBINAAN AKHLAK DAN IMAN', 'DRS. H. A. MUSTAFA', 67, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(12, '-', 'AL MATSURAT WIRID-WIRID RASULULLAH SAW PAGI DAN PETANG DI LENGKAPI DENGAN RIWAYAT DAN FADHILAHNYA', 'Tidak Ada', 34, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(13, '-', 'AL MATSURAT (WADZIFAH KUBRO DAN SUGHRO)  WIRID-WIRID RASULULLAH SAW PAGI DAN PETANG', 'Tidak Ada', 20, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(14, '-', 'AL QUR\'AN AL KARIM JUZ 30/AMMA (standar)', 'Tidak Ada', 73, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(15, '-', 'AL QUR\'AN AL KARIM JUZ 30/AMMA (kecil)', 'Tidak Ada', 56, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(16, '-', 'AL-AMTSILAH AT- TASHRIFIYAH', 'As-Syaikh Ma’shum bin Ali', 63, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(17, '-', 'AD-DHIYAUL LAAMI’ BIZIKRI MAULID', 'Al-Habib Al-‘Allamah Umar bin Muhammad bin Salim', 21, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(18, '-', 'AL LUGHOTU AL ARABIYAH (BAHASA ARAB)', 'USTADZ ABDUL JABBAR', 57, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(19, '-', 'DZIKIR PAGI-PETANG', 'SA\'ID BIN ALI WAHF AL QAHTHANI', 32, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(20, '-', 'FIQH ISLAM (HUKUM FIQH LENGKAP) VOL 1-10', 'H. SULAIMAN RASYID', 574, 10, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(21, '-', 'HIMPUNAN DOA-DOA PILIHAN', 'AHMAD SUNARTO', 81, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(22, '-', 'HIMPUNAN AYAT-AYAT AL QUR\'AN DAN KHASIAT BASMALAH, SURAT AL FATIHAH, AYAT KURSI, SURAT AL IKHLAS, SURAT AL QADR DAN ASMAUL HUSNA', 'MAHMUDZLI SAHLI', 68, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(23, '-', 'ILMU TAJWID (PEDOMAN MEMBACA AL QUR\'AN BRAILLE BAGI TUNANETRA)', 'TIM PENYUSUN BUKU YARFIN', 49, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(24, '-', 'ILMU NAHWU (TERJEMAHAN MATAN AL-AJRUMIYYAH DAN 1 IMRITHY BERIKUT PENJELASANNYA)', 'KH. MOH. ANWAR', 88, 2, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(25, '-', 'KELAS TAJWID UNTUK SEGALA USIA METODE SYAFII ILMU TAJWID PRAKTIS', 'ABU YA\'LA KURNAEDI, LC. NIZAR SAAD JABAL, LC. M.PD', 72, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(26, '-', 'KAMUS MAHMUD YUNUS', 'PROF. DR. H. MUHAMMAD YUNUS', 699, 13, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(27, '-', 'KITABU AL AKHLAQI LILBANIN', 'AL USTADZ BIN AHMAD BAROJA', 25, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(28, '-', 'MAJMUATU AL-MAWALID SARAFUL AN-NAM BARZANZI', 'PENERBIT PT. DAHLAN INDONESIA', 142, 2, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(29, '-', 'MAULID SIMTUDDUROR DAN SHOLAWAT NABI MUHAMMAD SAW', 'Ali bin Muhammad bin Husain Al-Habsyi', 44, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(30, '-', 'MUNAJAT (WIRID & DOA) DALAM AL QUR\'AN', 'KHR. SYARIF RAHMAT, RA', 41, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(31, '-', 'PANDAI MEMBACA AL QUR\'AN (METODE CEPAT DAN PRAKTIS MEMBACA AL QUR\'AN BRAILLE) EDISI REVISI', 'TIM PENYUSUN BUKU YARFIN', 39, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(32, '-', 'PANDUAN UMROH DAN HAJI, KUMPULAN DOA (EDISI 2017)', 'Tidak Ada', 102, 2, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(33, '-', 'RISALAH TUNTUNAN SHOLAT LENGKAP 2 vol', 'DRS. MOH. RIFA\'I', 109, 2, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(34, '-', 'RATIBUL HADAD + ASMAULHUSNA + TAHLIL + DOA', 'Tidak Ada', 22, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(35, '-', 'RATIBUL ATOS + RATIBUL HADAD', 'Tidak Ada', 27, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(36, '-', 'RATIBUL ATOS + RATIBUL HADAD + ASMAUL HUSNA', 'Tidak Ada', 28, 1, 'k', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(37, '-', 'SURAH YASIN DILENGKAPI BACAAN DZIKIR, TAHLIL DAN DOA', 'TIM PENYUSUN BUKU YARFIN', 23, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(38, '-', 'SURAH YASIN DAN ASMAUL HUSNA DILENGKAPI BACAAN DZIKIR, TAHLIL DAN DOA', 'TIM PENYUSUN BUKU YARFIN', 29, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(39, '-', 'SURAH YASIN DAN TERJEMAHNYA', 'TIM PENYUSUN BUKU YARFIN', 26, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(40, '-', 'SURAH AL-KAHFI DAN TERJEMAHNYA', 'Tidak Ada', 26, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(41, '-', 'TERJEMAH HADITS ARBAIN ANNAWAWIYAH (40 HADITS PILIHAN)', 'AS SYEIKH IMAM NAWI', 41, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(42, '-', 'TERJEMAH MATAN SAFINATUNNAJAH DASAR-DASAR FIQH MAZHAB SYAFI\'I', 'SYEIKH SALIM BIN SUMAIR AL HADHRAMIY', 41, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(43, '-', 'TERJEMAHAN TA\'LIMUL MUTA\'ALIM', 'A. SUNARTO', 116, 2, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(44, '-', 'Himpunan 5 Surat Pilihan (Tanpa Surat Al Dukhon, As Sajaddah)', 'Tidak Ada', 48, 1, 'k', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(45, '-', 'Maulid Diba\'i', 'Tidak Ada', 22, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(46, '-', 'Barzanzi / Rawi Singkat', 'Tidak Ada', 15, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(47, '-', 'Rawi Singkat Dan Maulid Diba\'i', 'Tidak Ada', 23, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(48, '-', 'AKIDATUL AWAM', 'Tidak Ada', 21, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(49, '-', 'Kalender 2024 M', 'Tidak Ada', 26, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(50, '-', 'Kalender 2025 M', 'Tidak Ada', 26, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(51, '-', 'Kalender Meja 2025 M', 'Tidak Ada', 12, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(52, '-', 'Dzikir Pagi Petang Dan Nadhom', 'Tidak Ada', 42, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(53, '-', 'Terjemah Jazariyah Tuhfah (B)', 'Tidak Ada', 96, 2, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(54, '-', 'Matan Jazariyah (K)', 'Tidak Ada', 16, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(55, '-', 'Dzikir Pagi-Petang Dan Nadzhom Asmaul Husna (Request)', 'Tidak Ada', 42, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(56, '-', 'Buku tulis braille ukuran besar 50 Eks', 'Tidak Ada', 50, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(57, '-', 'Buku tulis braille ukuran besar 25 Eks', 'Tidak Ada', 25, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(58, '-', 'Buku tulis braille ukuran kecil 50 Eks', 'Tidak Ada', 50, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(59, '-', 'Buku tulis braille ukuran kecil 25 Eks', 'Tidak Ada', 25, 1, 'K', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(60, '-', 'Buku ilmu tajwid Braille (Versi full colour)', 'Tidak Ada', 49, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(61, '-', 'Buku pandai membaca Al-Quran braille (versi full colour)', 'Tidak Ada', 39, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(62, '-', 'Buku pandai membaca Al-Quran (versi awas)', 'Tidak Ada', 39, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(63, '-', 'Ratibul Hadad, Asmaul Husna, Sholawat Burdah', 'Tidak Ada', 19, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19'),
(64, '-', 'Sholawat Burdah', 'Tidak Ada', 15, 1, 'S', '-', '0000', 0.00, '2026-05-12 05:35:19');

-- --------------------------------------------------------

--
-- Table structure for table `log_konversi`
--

CREATE TABLE `log_konversi` (
  `id_log` int(11) NOT NULL,
  `nama_file` varchar(255) DEFAULT NULL,
  `jumlah_sukses` int(11) DEFAULT NULL,
  `jumlah_gagal` int(11) DEFAULT NULL,
  `waktu_eksekusi` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_konversi`
--

INSERT INTO `log_konversi` (`id_log`, `nama_file`, `jumlah_sukses`, `jumlah_gagal`, `waktu_eksekusi`) VALUES
(30, 'Upload_20260511_072028.xlsx', 64, 0, '2026-05-11 12:20:28'),
(31, 'Upload_20260511_080514.xlsx', 64, 0, '2026-05-11 13:05:14'),
(32, 'Upload_20260512_055917.xlsx', 64, 0, '2026-05-12 10:59:17'),
(33, 'Upload_20260512_062947.xlsx', 0, 64, '2026-05-12 11:29:47'),
(34, 'Upload_20260512_063949.xlsx', 20, 10, '2026-05-12 11:39:49'),
(35, 'Upload_20260512_064156.xlsx', 64, 0, '2026-05-12 11:41:56'),
(36, 'Upload_20260512_065205.xlsx', 0, 64, '2026-05-12 11:52:05'),
(37, 'Upload_20260512_065656.xlsx', 0, 64, '2026-05-12 11:56:56'),
(38, 'Upload_20260512_071806.xlsx', 0, 64, '2026-05-12 12:18:06'),
(39, 'Upload_20260512_073019.xlsx', 0, 64, '2026-05-12 12:30:19'),
(40, 'Upload_20260512_073415.xlsx', 0, 64, '2026-05-12 12:34:15'),
(41, 'Upload_20260512_073519.xlsx', 64, 0, '2026-05-12 12:35:19'),
(42, 'Upload_20260512_073820.xlsx', 0, 64, '2026-05-12 12:38:20'),
(43, 'Upload_20260512_074654.xlsx', 0, 64, '2026-05-12 12:46:54');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `log_konversi`
--
ALTER TABLE `log_konversi`
  ADD PRIMARY KEY (`id_log`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `log_konversi`
--
ALTER TABLE `log_konversi`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
