-- tabel distribusi
CREATE TABLE distribusi (
  id_distribusi       INT AUTO_INCREMENT PRIMARY KEY,
  id_menu             INT NOT NULL,
  id_sekolah          INT NOT NULL,
  tanggal_distribusi  DATE NOT NULL,
  jumlah_porsi        INT NOT NULL,
  status_distribusi   ENUM('dijadwalkan', 'dikirim', 'selesai', 'dibatalkan') NOT NULL DEFAULT 'dijadwalkan',
  CONSTRAINT chk_distribusi_porsi CHECK (jumlah_porsi > 0),
  CONSTRAINT uq_distribusi_menu_sekolah UNIQUE (id_menu, id_sekolah),
  CONSTRAINT fk_distribusi_menu FOREIGN KEY (id_menu)
    REFERENCES menu_harian(id_menu) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_distribusi_sekolah FOREIGN KEY (id_sekolah)
    REFERENCES sekolah(id_sekolah) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- tabel pengiriman
CREATE TABLE pengiriman (
  id_pengiriman       INT AUTO_INCREMENT PRIMARY KEY,
  id_distribusi       INT NOT NULL UNIQUE,
  id_petugas          INT NOT NULL,
  nama_kurir          VARCHAR(100) NOT NULL,
  no_kendaraan        VARCHAR(20) NOT NULL,
  waktu_berangkat     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  waktu_tiba          DATETIME NULL,
  status_pengiriman   ENUM('perjalanan', 'sampai', 'terkendala') NOT NULL DEFAULT 'perjalanan',
  CONSTRAINT chk_pengiriman_waktu CHECK (waktu_tiba IS NULL OR waktu_tiba >= waktu_berangkat),
  CONSTRAINT fk_pengiriman_distribusi FOREIGN KEY (id_distribusi)
    REFERENCES distribusi(id_distribusi) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pengiriman_petugas FOREIGN KEY (id_petugas)
    REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- tabel penerimaan_makanan
CREATE TABLE penerimaan_makanan (
  id_penerimaan       INT AUTO_INCREMENT PRIMARY KEY,
  id_pengiriman       INT NOT NULL UNIQUE,
  id_pengguna_sekolah INT NOT NULL,
  porsi_diterima      INT NOT NULL,
  porsi_rusak         INT NOT NULL DEFAULT 0,
  status_penerimaan   ENUM('diterima_lengkap', 'diterima_sebagian', 'ditolak') NOT NULL DEFAULT 'diterima_lengkap',
  waktu_terima        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  catatan             VARCHAR(255) NULL,
  CONSTRAINT chk_penerimaan_porsi CHECK (porsi_diterima >= 0 AND porsi_rusak >= 0),
  CONSTRAINT fk_penerimaan_pengiriman FOREIGN KEY (id_pengiriman)
    REFERENCES pengiriman(id_pengiriman) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_penerimaan_sekolah_user FOREIGN KEY (id_pengguna_sekolah)
    REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
