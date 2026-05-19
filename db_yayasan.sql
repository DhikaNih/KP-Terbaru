-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 19, 2026 at 03:31 AM
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
  `tgl_input` timestamp NOT NULL DEFAULT current_timestamp(),
  `batch_id` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `kode_buku`, `judul_buku`, `penulis`, `jumlah_lembar`, `volume`, `kode_ukuran`, `ukuran_buku`, `tahun_terbit`, `harga`, `tgl_input`, `batch_id`) VALUES
(538, '-', 'Al Qur\'an + Terjemah (Standar)', 'Tidak Ada', 1553, 30, 'S', '-', '2000', 0.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(539, '-', 'Al Qur\'an Tanpa Terjemah (Tadarus)', 'Tidak Ada', 1145, 30, 'K', '-', '2000', 0.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(540, '-', 'Al-qur\'an 3 In 1', 'Tidak Ada', 620, 10, 'S', '-', '2000', 0.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(541, '-', 'Al-qur\'an 2 In 1', 'Tidak Ada', 0, 0, 'K', '-', '2000', 0.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(542, '-', '7 Surat Pilihan + Terjemah (Al Kahfi, As Sajdah, Yasin, Al Dukhon, Al Rahman, Al Waqiah, Al Mulk)', 'TIM PENYUSUN BUKU YARFIN', 76, 1, 'S', '-', '2000', 53000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(543, '-', '7 Surat Pilihan (Tanpa Terjemah) (Al Kahfi, As Sajdah, Yasin, Al Dukhon, Al Rahman, Al Waqiah, Al Mulk)', 'TIM PENYUSUN BUKU YARFIN', 32, 1, 'S', '-', '2000', 31000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(544, '-', '7 Surat Pilihan (Buku Kecil) (Al Kahfi, As Sajdah, Yasin, Al Dukhon, Al Rahman, Al Waqiah, Al Mulk)', 'TIM PENYUSUN BUKU YARFIN', 58, 1, 'K', '-', '2000', 27000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(545, '-', '7 Surat Pilihan +Bacaan Zikir, Tahlil Dan Doa + Asmaul Husna (Tanpa Terjemah)', 'TIM PENYUSUN BUKU YARFIN', 40, 1, 'S', '-', '2000', 35000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(546, '-', '8 Surat Pilihan Tanpa Terjemah (Al Baqarah, Al Kahfi, As Sajdah, Yasin, Al Dukhon, Al Rahman, Al Waqiah, Al Mulk)', 'TIM PENYUSUN BUKU YARFIN', 69, 1, 'S', '-', '2000', 49500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(547, '-', '11 Surat Pilihan (Yusuf, Kahfi, Maryam, Lukman, As Sajdah, Yasin, Ad Dukhan, Ar Rahman, Al Waqiah, Al Hasyr, Al Mulk)', 'TIM PENYUSUN BUKU YARFIN', 58, 1, 'S', '-', '2000', 44000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(548, '-', '150 Hadits Pilihan Untuk Pembinaan Akhlak Dan Iman', 'DRS. H. A. MUSTAFA', 67, 1, 'S', '-', '2000', 48500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(549, '-', 'Al Matsurat Wirid-wirid Rasulullah Saw Pagi Dan Petang Di Lengkapi Dengan Riwayat Dan Fadhilahnya', 'Tidak Ada', 34, 1, 'S', '-', '2000', 32000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(550, '-', 'Al Matsurat (Wadzifah Kubro Dan Sughro) Wirid-wirid Rasulullah Saw Pagi Dan Petang', 'Tidak Ada', 20, 1, 'K', '-', '2000', 17500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(551, '-', 'Al Qur\'an Al Karim Juz 30/amma (Standar)', 'Tidak Ada', 73, 1, 'S', '-', '2000', 51500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(552, '-', 'Al Qur\'an Al Karim Juz 30/amma (Kecil)', 'Tidak Ada', 56, 1, 'K', '-', '2000', 26500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(553, '-', 'Al-amtsilah At- Tashrifiyah', 'As-Syaikh Ma’shum bin Ali', 63, 1, 'S', '-', '2000', 46500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(554, '-', 'Ad-dhiyaul Laami’ Bizikri Maulid', 'Al-Habib Al-‘Allamah Umar bin Muhammad bin Salim', 21, 1, 'K', '-', '2000', 17750.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(555, '-', 'Al Lughotu Al Arabiyah (Bahasa Arab)', 'USTADZ ABDUL JABBAR', 57, 1, 'S', '-', '2000', 43500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(556, '-', 'Dzikir Pagi-petang', 'SA\'ID BIN ALI WAHF AL QAHTHANI', 32, 1, 'K', '-', '2000', 20500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(557, '-', 'Fiqh Islam (Hukum Fiqh Lengkap) Vol 1-10', 'H. SULAIMAN RASYID', 574, 10, 'S', '-', '2000', 437000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(558, '-', 'Himpunan Doa-doa Pilihan', 'AHMAD SUNARTO', 81, 1, 'S', '-', '2000', 55500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(559, '-', 'Himpunan Ayat-ayat Al Qur\'an Dan Khasiat Basmalah, Surat Al Fatihah, Ayat Kursi, Surat Al Ikhlas, Surat Al Qadr Dan Asmaul Husna', 'MAHMUDZLI SAHLI', 68, 1, 'S', '-', '2000', 49000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(560, '-', 'Ilmu Tajwid (Pedoman Membaca Al Qur\'an Braille Bagi Tunanetra)', 'TIM PENYUSUN BUKU YARFIN', 49, 1, 'S', '-', '2000', 39500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(561, '-', 'Ilmu Nahwu (Terjemahan Matan Al-ajrumiyyah Dan 1 Imrithy Berikut Penjelasannya)', 'KH. MOH. ANWAR', 88, 2, 'S', '-', '2000', 74000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(562, '-', 'Kelas Tajwid Untuk Segala Usia Metode Syafii Ilmu Tajwid Praktis', 'ABU YA\'LA KURNAEDI, LC. NIZAR SAAD JABAL, LC. M.PD', 72, 1, 'S', '-', '2000', 51000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(563, '-', 'Kamus Mahmud Yunus', 'PROF. DR. H. MUHAMMAD YUNUS', 699, 13, 'S', '-', '2000', 544500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(564, '-', 'Kitabu Al Akhlaqi Lilbanin', 'AL USTADZ BIN AHMAD BAROJA', 25, 1, 'S', '-', '2000', 27500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(565, '-', 'Majmuatu Al-mawalid Saraful An-nam Barzanzi', 'PENERBIT PT. DAHLAN INDONESIA', 142, 2, 'S', '-', '2000', 101000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(566, '-', 'Maulid Simtudduror Dan Sholawat Nabi Muhammad Saw', 'Ali bin Muhammad bin Husain Al-Habsyi', 44, 1, 'K', '-', '2000', 23500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(567, '-', 'Munajat (Wirid & Doa) Dalam Al Qur\'an', 'KHR. SYARIF RAHMAT, RA', 41, 1, 'S', '-', '2000', 35500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(568, '-', 'Pandai Membaca Al Qur\'an (Metode Cepat Dan Praktis Membaca Al Qur\'an Braille) Edisi Revisi', 'TIM PENYUSUN BUKU YARFIN', 39, 1, 'S', '-', '2000', 34500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(569, '-', 'Panduan Umroh Dan Haji, Kumpulan Doa (Edisi 2017)', 'Tidak Ada', 102, 2, 'S', '-', '2000', 81000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(570, '-', 'Risalah Tuntunan Sholat Lengkap 2 Vol', 'DRS. MOH. RIFA\'I', 109, 2, 'S', '-', '2000', 84500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(571, '-', 'Ratibul Hadad + Asmaulhusna + Tahlil + Doa', 'Tidak Ada', 22, 1, 'K', '-', '2000', 18000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(572, '-', 'Ratibul Atos + Ratibul Hadad', 'Tidak Ada', 27, 1, 'K', '-', '2000', 19250.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(573, '-', 'Ratibul Atos + Ratibul Hadad + Asmaul Husna', 'Tidak Ada', 28, 1, 'k', '-', '2000', 19500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(574, '-', 'Surah Yasin Dilengkapi Bacaan Dzikir, Tahlil Dan Doa', 'TIM PENYUSUN BUKU YARFIN', 23, 1, 'K', '-', '2000', 18250.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(575, '-', 'Surah Yasin Dan Asmaul Husna Dilengkapi Bacaan Dzikir, Tahlil Dan Doa', 'TIM PENYUSUN BUKU YARFIN', 29, 1, 'K', '-', '2000', 19750.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(576, '-', 'Surah Yasin Dan Terjemahnya', 'TIM PENYUSUN BUKU YARFIN', 26, 1, 'K', '-', '2000', 19000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(577, '-', 'Surah Al-kahfi Dan Terjemahnya', 'Tidak Ada', 26, 1, 'S', '-', '2000', 28000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(578, '-', 'Terjemah Hadits Arbain Annawawiyah (40 Hadits Pilihan)', 'AS SYEIKH IMAM NAWI', 41, 1, 'S', '-', '2000', 35500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(579, '-', 'Terjemah Matan Safinatunnajah Dasar-dasar Fiqh Mazhab Syafi\'i', 'SYEIKH SALIM BIN SUMAIR AL HADHRAMIY', 41, 1, 'S', '-', '2000', 35500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(580, '-', 'Terjemahan Ta\'limul Muta\'alim', 'A. SUNARTO', 116, 2, 'S', '-', '2000', 88000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(581, '-', 'Himpunan 5 Surat Pilihan (Tanpa Surat Al Dukhon, As Sajaddah)', 'Tidak Ada', 48, 1, 'k', '-', '2000', 24500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(582, '-', 'Maulid Diba\'i', 'Tidak Ada', 22, 1, 'S', '-', '2000', 26000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(583, '-', 'Barzanzi / Rawi Singkat', 'Tidak Ada', 15, 1, 'S', '-', '2000', 22500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(584, '-', 'Rawi Singkat Dan Maulid Diba\'i', 'Tidak Ada', 23, 1, 'S', '-', '2000', 26500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(585, '-', 'Akidatul Awam', 'Tidak Ada', 21, 1, 'S', '-', '2000', 25500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(586, '-', 'Kalender 2024 M', 'Tidak Ada', 26, 1, 'K', '-', '2000', 14500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(587, '-', 'Kalender 2025 M', 'Tidak Ada', 26, 1, 'K', '-', '2000', 14500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(588, '-', 'Kalender Meja 2025 M', 'Tidak Ada', 12, 1, 'K', '-', '2000', 0.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(589, '-', 'Dzikir Pagi Petang Dan Nadhom', 'Tidak Ada', 42, 1, 'K', '-', '2000', 23000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(590, '-', 'Terjemah Jazariyah Tuhfah (B)', 'Tidak Ada', 96, 2, 'S', '-', '2000', 78000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(591, '-', 'Matan Jazariyah (K)', 'Tidak Ada', 16, 1, 'K', '-', '2000', 11500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(592, '-', 'Dzikir Pagi-petang Dan Nadzhom Asmaul Husna (Request)', 'Tidak Ada', 42, 1, 'K', '-', '2000', 23000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(593, '-', 'Buku Tulis Braille Ukuran Besar 50 Eks', 'Tidak Ada', 50, 1, 'S', '-', '2000', 22250.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(594, '-', 'Buku Tulis Braille Ukuran Besar 25 Eks', 'Tidak Ada', 25, 1, 'S', '-', '2000', 12875.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(595, '-', 'Buku Tulis Braille Ukuran Kecil 50 Eks', 'Tidak Ada', 50, 1, 'K', '-', '2000', 13500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(596, '-', 'Buku Tulis Braille Ukuran Kecil 25 Eks', 'Tidak Ada', 25, 1, 'K', '-', '2000', 8500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(597, '-', 'Buku Ilmu Tajwid Braille (Versi Full Colour)', 'Tidak Ada', 49, 1, 'S', '-', '2000', 39500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(598, '-', 'Buku Pandai Membaca Al-quran Braille (Versi Full Colour)', 'Tidak Ada', 39, 1, 'S', '-', '2000', 34500.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(599, '-', 'Buku Pandai Membaca Al-quran (Versi Awas)', 'Tidak Ada', 39, 1, 'S', '-', '2000', 36450.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(600, '-', 'Ratibul Hadad, Asmaul Husna, Sholawat Burdah', 'Tidak Ada', 19, 1, 'S', '-', '2000', 0.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(601, '-', 'Sholawat Burdah', 'Tidak Ada', 15, 1, 'S', '-', '2000', 0.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96'),
(602, '-', 'Coba Dulu', 'Tidak Ada', 35, 1, 'S', '-', '2000', 50000.00, '2026-05-18 06:27:05', 'batch_20260518082705_7a9c8f96');

-- --------------------------------------------------------

--
-- Table structure for table `log_konversi`
--

CREATE TABLE `log_konversi` (
  `id_log` int(11) NOT NULL,
  `nama_file` varchar(255) DEFAULT NULL,
  `jumlah_sukses` int(11) DEFAULT NULL,
  `jumlah_gagal` int(11) DEFAULT NULL,
  `detail_error` text DEFAULT NULL,
  `waktu_eksekusi` datetime DEFAULT current_timestamp(),
  `batch_id` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log_konversi`
--

INSERT INTO `log_konversi` (`id_log`, `nama_file`, `jumlah_sukses`, `jumlah_gagal`, `detail_error`, `waktu_eksekusi`, `batch_id`) VALUES
(49, '[ROLLBACK] Batch batch_20260517051040_36e08c41', 0, 0, 'Rollback menghapus 65 buku', '2026-05-17 10:14:24', 'batch_20260517051040_36e08c41'),
(57, 'daftar harga katalog dengan spiral kawat ok.xlsx', 65, 0, NULL, '2026-05-18 13:27:05', 'batch_20260518082705_7a9c8f96');

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
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=603;

--
-- AUTO_INCREMENT for table `log_konversi`
--
ALTER TABLE `log_konversi`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
