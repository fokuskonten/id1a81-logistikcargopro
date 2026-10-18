-- ========================================================
-- FOKUSKONTEN OFFICIAL DATABASE SCHEME
-- SKU: ID1A81 | Aplikasi: LogistikCargoPro
-- Kurasi & Distribusi: FokusKonten Digital (fokuskonten.my.id)
-- Kompatibilitas: MySQL 5.7+ / MariaDB 10.4+ / XAMPP / Laragon
-- ========================================================

-- DDL Schema untuk database db_logistik_cargo
-- Digunakan untuk proyek UAS Pemrograman Berorientasi Objek (PBO) - CargoFlow

-- [SANITASI FOKUSKONTEN] CREATE DATABASE IF NOT EXISTS db_logistik_cargo;
-- [SANITASI FOKUSKONTEN] USE db_logistik_cargo;

-- 1. Tabel Utama / Induk Kargo
CREATE TABLE IF NOT EXISTS kargo (
    id_resi VARCHAR(50) PRIMARY KEY,
    pengirim VARCHAR(100) NOT NULL,
    kota_tujuan VARCHAR(100) NOT NULL,
    berat_barang DECIMAL(10,2) NOT NULL,
    tarif_dasar_per_kg DECIMAL(10,2) NOT NULL,
    jenis_kargo VARCHAR(50) NOT NULL,
    total_tarif DECIMAL(15,2) NOT NULL,
    status_packing ENUM('TERPENUHI', 'BELUM TERPENUHI') NOT NULL,
    tanggal_reservasi DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Tabel Detail Kargo Reguler
CREATE TABLE IF NOT EXISTS kargo_reguler (
    id_resi VARCHAR(50) PRIMARY KEY,
    jenis_paket ENUM('Koli', 'Dus') NOT NULL,
    estimasi_hari INT NOT NULL,
    FOREIGN KEY (id_resi) REFERENCES kargo(id_resi) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Tabel Detail Kargo Bahan Kimia
CREATE TABLE IF NOT EXISTS kargo_bahan_kimia (
    id_resi VARCHAR(50) PRIMARY KEY,
    tingkat_bahaya INT NOT NULL,
    jenis_sertifikasi_sandi VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_resi) REFERENCES kargo(id_resi) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Tabel Detail Kargo Pecah Belah
CREATE TABLE IF NOT EXISTS kargo_pecah_belah (
    id_resi VARCHAR(50) PRIMARY KEY,
    ketebalan_bubble_wrap INT NOT NULL,
    biaya_asuransi_wajib DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (id_resi) REFERENCES kargo(id_resi) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================================
-- DATA AWAL SIMULASI OPERASIONAL (FOKUSKONTEN OFFICIAL SEED)
-- ========================================================
INSERT IGNORE INTO kargo (id_resi, pengirim, kota_tujuan, berat_barang, tarif_dasar_per_kg, jenis_kargo, total_tarif, status_packing, tanggal_reservasi) VALUES
('RESI-REG-001', 'PT Jaya Mandiri Logistik', 'Surabaya', 150.00, 4500.00, 'Reguler', 675000.00, 'TERPENUHI', '2026-10-15 09:30:00'),
('RESI-REG-002', 'CV Berkah Sentosa', 'Semarang', 85.00, 5000.00, 'Reguler', 425000.00, 'TERPENUHI', '2026-10-16 11:15:00'),
('RESI-KIM-001', 'PT Petro Multi Kimia', 'Cilegon', 500.00, 8000.00, 'BahanKimia', 4800000.00, 'TERPENUHI', '2026-10-17 14:00:00'),
('RESI-KIM-002', 'CV Indo Chem Prima', 'Bandung', 250.00, 8500.00, 'BahanKimia', 2450000.00, 'TERPENUHI', '2026-10-17 16:45:00'),
('RESI-PCB-001', 'CV Surya Pratama Keramik', 'Yogyakarta', 120.00, 6000.00, 'PecahBelah', 920000.00, 'TERPENUHI', '2026-10-18 08:20:00'),
('RESI-PCB-002', 'UD Maju Kaca Perkasa', 'Malang', 340.00, 6500.00, 'PecahBelah', 2510000.00, 'TERPENUHI', '2026-10-18 10:30:00'),
('RESI-REG-003', 'Toko Elektronik Nusantara', 'Medan', 210.00, 12000.00, 'Reguler', 2520000.00, 'TERPENUHI', '2026-10-18 13:00:00');

INSERT IGNORE INTO kargo_reguler (id_resi, jenis_paket, estimasi_hari) VALUES
('RESI-REG-001', 'Dus', 2),
('RESI-REG-002', 'Koli', 3),
('RESI-REG-003', 'Dus', 4);

INSERT IGNORE INTO kargo_bahan_kimia (id_resi, tingkat_bahaya, jenis_sertifikasi_sandi) VALUES
('RESI-KIM-001', 3, 'MSDS-CERT-88912-B'),
('RESI-KIM-002', 2, 'MSDS-CERT-44109-A');

INSERT IGNORE INTO kargo_pecah_belah (id_resi, ketebalan_bubble_wrap, biaya_asuransi_wajib) VALUES
('RESI-PCB-001', 3, 200000.00),
('RESI-PCB-002', 5, 300000.00);
