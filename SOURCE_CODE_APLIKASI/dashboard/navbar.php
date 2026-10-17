<?php
// FokusKonten PHP 8.2 Compatibility Shield
error_reporting(E_ALL & ~E_NOTICE & ~E_DEPRECATED & ~E_WARNING);
ini_set('display_errors', '0');

// navbar.php - Simple Clean Navigation
$current_page = basename($_SERVER['PHP_SELF']);
?>
<nav class="navbar">
    <div class="navbar-container">
        <div class="navbar-left">
            <a href="index.php" class="navbar-logo" style="display: flex; align-items: center; gap: 10px; text-decoration: none;">
                <img src="../logo.svg" onerror="this.onerror=null; this.src='../logo.png';" alt="LogistikCargoPro" style="height: 38px; width: 38px; border-radius: 50%; object-fit: cover; display: inline-block; box-shadow: 0 2px 8px rgba(37,99,235,0.25);">
                <span class="logo-text" style="font-weight: 700; font-size: 18px; color: #1e3a8a; letter-spacing: -0.3px;">LogistikCargoPro</span>
            </a>
        </div>
        <div class="navbar-right">
            <div class="navbar-info">
                <span class="info-label">Ekspedisi Muatan Truk</span>
                <span class="info-value">Hitung Berat & Kubikasi</span>
            </div>
            <div class="navbar-divider"></div>
            <div class="navbar-user">
                <div class="user-avatar" style="background: linear-gradient(135deg, #1d4ed8 0%, #2563eb 100%);">A</div>
                <span class="user-name">Admin Logistik</span>
            </div>
        </div>
    </div>
</nav>
