<?php
// FokusKonten PHP 8.2 Compatibility Shield
error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED & ~E_WARNING);
ini_set('display_errors', '0');

require_once __DIR__ . '/../classes/Kargo.php';
require_once __DIR__ . '/../config/connection.php';

function formatRupiah($amount) {
    return 'Rp ' . number_format($amount, 0, ',', '.');
}

// Fetch stats and all cargos
try {
    $qStats = $pdo->query("SELECT 
        COUNT(*) as total_kargo,
        COALESCE(SUM(berat_barang), 0) as total_berat,
        COALESCE(SUM(total_tarif), 0) as total_pendapatan,
        SUM(CASE WHEN status_packing='TERPENUHI' THEN 1 ELSE 0 END) as packing_ok
        FROM kargo");
    $stats = $qStats->fetch(PDO::FETCH_ASSOC);

    $qList = $pdo->query("SELECT * FROM kargo ORDER BY tanggal_reservasi DESC");
    $cargoList = $qList->fetchAll(PDO::FETCH_ASSOC);
} catch (Exception $e) {
    $stats = ['total_kargo' => 0, 'total_berat' => 0, 'total_pendapatan' => 0, 'packing_ok' => 0];
    $cargoList = [];
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <link rel="icon" type="image/x-icon" href="favicon.ico">
    <link rel="icon" type="image/png" sizes="16x16" href="favicon-16x16.png">
    <link rel="icon" type="image/png" sizes="32x32" href="favicon-32x32.png">
    <link rel="apple-touch-icon" sizes="192x192" href="favicon-192x192.png">
    <link rel="manifest" href="manifest.json">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan & Analitik Pengiriman — LogistikCargoPro</title>
    <link rel="stylesheet" href="../assets/css/style.css">
</head>
<body>

<?php include 'navbar.php'; ?>
<?php include 'sidebar.php'; ?>

<main class="main-content">
<div class="container">

    <div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
        <div>
            <h1 class="page-title" style="margin-bottom: 4px;">Laporan & Rekapitulasi Manifest Ekspedisi</h1>
            <p class="page-subtitle">Monitoring muatan truk, status berat angkut, kubikasi, dan omzet pengiriman logistik</p>
        </div>
        <button class="btn btn-primary" onclick="window.print();" style="display: inline-flex; align-items: center; gap: 8px;">
            🖨️ Cetak Laporan Manifest
        </button>
    </div>

    <!-- 4 KARTU STATISTIK -->
    <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 24px;">
        <div class="card" style="padding: 20px; border-left: 4px solid #2563eb;">
            <div style="font-size: 13px; color: #64748b; font-weight: 500;">Total Manifest Kargo</div>
            <div style="font-size: 26px; font-weight: 700; color: #1e3a8a; margin-top: 6px;"><?= (int)$stats['total_kargo'] ?> Resi</div>
            <div style="font-size: 12px; color: #10b981; margin-top: 4px; font-weight: 500;">Aktif & Terjadwal</div>
        </div>
        <div class="card" style="padding: 20px; border-left: 4px solid #059669;">
            <div style="font-size: 13px; color: #64748b; font-weight: 500;">Total Berat Angkut</div>
            <div style="font-size: 26px; font-weight: 700; color: #065f46; margin-top: 6px;"><?= number_format($stats['total_berat'], 1, ',', '.') ?> kg</div>
            <div style="font-size: 12px; color: #64748b; margin-top: 4px;">Muatan Truk Terdata</div>
        </div>
        <div class="card" style="padding: 20px; border-left: 4px solid #d97706;">
            <div style="font-size: 13px; color: #64748b; font-weight: 500;">Kargo Terpenuhi</div>
            <div style="font-size: 26px; font-weight: 700; color: #92400e; margin-top: 6px;"><?= (int)$stats['packing_ok'] ?> / <?= (int)$stats['total_kargo'] ?></div>
            <div style="font-size: 12px; color: #64748b; margin-top: 4px;">Siap Muat & Berangkat</div>
        </div>
        <div class="card" style="padding: 20px; border-left: 4px solid #7c3aed;">
            <div style="font-size: 13px; color: #64748b; font-weight: 500;">Total Omzet Ekspedisi</div>
            <div style="font-size: 22px; font-weight: 700; color: #5b21b6; margin-top: 8px;"><?= formatRupiah($stats['total_pendapatan']) ?></div>
            <div style="font-size: 12px; color: #10b981; margin-top: 4px; font-weight: 500;">Pendapatan Bruto</div>
        </div>
    </div>

    <!-- TABEL MANIFEST -->
    <div class="table-card">
        <div class="table-header" style="display: flex; justify-content: space-between; align-items: center;">
            <h3 class="table-header-title">Daftar Manifest Pengiriman Kargo & Muatan Truk</h3>
            <span style="font-size: 13px; color: #64748b;">Periode Aktif: Oktober 2026</span>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>No Resi</th>
                        <th>Tanggal</th>
                        <th>Pengirim</th>
                        <th>Kota Tujuan</th>
                        <th>Kategori</th>
                        <th>Berat</th>
                        <th>Total Biaya</th>
                        <th>Status Packing</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($cargoList)): ?>
                        <tr><td colspan="8" style="text-align: center; padding: 24px;">Belum ada data kargo.</td></tr>
                    <?php else: ?>
                        <?php foreach ($cargoList as $c): ?>
                            <tr>
                                <td><strong style="color: #2563eb; font-family: monospace; font-size: 13px;"><?= htmlspecialchars($c['id_resi']) ?></strong></td>
                                <td><?= date('d/m/Y H:i', strtotime($c['tanggal_reservasi'])) ?></td>
                                <td><strong><?= htmlspecialchars($c['pengirim']) ?></strong></td>
                                <td><?= htmlspecialchars($c['kota_tujuan']) ?></td>
                                <td>
                                    <?php if ($c['jenis_kargo'] === 'Reguler'): ?>
                                        <span class="badge badge-primary">Reguler</span>
                                    <?php elseif ($c['jenis_kargo'] === 'BahanKimia'): ?>
                                        <span class="badge badge-warning">Bahan Kimia</span>
                                    <?php else: ?>
                                        <span class="badge badge-danger">Pecah Belah</span>
                                    <?php endif; ?>
                                </td>
                                <td><?= number_format($c['berat_barang'], 1, ',', '.') ?> kg</td>
                                <td><strong><?= formatRupiah($c['total_tarif']) ?></strong></td>
                                <td>
                                    <?php if ($c['status_packing'] === 'TERPENUHI'): ?>
                                        <span class="badge badge-success">Terpenuhi</span>
                                    <?php else: ?>
                                        <span class="badge badge-danger">Belum Terpenuhi</span>
                                    <?php endif; ?>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>

    <!-- FOOTER WATERMARK -->
    <div style="margin-top: 40px; margin-bottom: 20px; text-align: center; color: #64748b; font-size: 13px;">
        LogistikCargoPro &bull; Software Ekspedisi Muatan Truk Hitung Berat Dan Kubikasi<br>
        Powered by <a href="https://fokuskonten.my.id" target="_blank" style="color: #2563eb; font-weight: 600; text-decoration: none;">FokusKonten</a>
    </div>

</div>
</main>

</body>
</html>