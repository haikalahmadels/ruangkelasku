/// Semua teks UI. Label navigasi mengikuti Google Classroom versi Indonesia.
/// Tanpa tanda pisah panjang (docs/design.md, bagian Teks UI).
abstract final class S {
  // Aplikasi
  static const appName = 'RuangKelasku';

  // Umum
  static const retry = 'Coba lagi';
  static const cancel = 'Batal';
  static const save = 'Simpan';
  static const close = 'Tutup';
  static const done = 'Selesai';
  static const more = 'Opsi lainnya';
  static const copy = 'Salin';
  static const copied = 'Disalin';
  static const loadMore = 'Muat lainnya';
  static const required = 'Wajib diisi';
  static const errorGeneric = 'Terjadi kesalahan. Coba lagi sebentar lagi.';
  static const errorNetwork = 'Hmm, koneksinya putus. Periksa internet atau server, lalu coba lagi.';
  static const errorNotFound = 'Data tidak ditemukan atau sudah dihapus.';
  static const justNow = 'Baru saja';
  static const yesterday = 'Kemarin';
  static String minutesAgo(int n) => '$n menit lalu';
  static String hoursAgo(int n) => '$n jam lalu';
  static String dueAt(String date) => 'Tenggat $date';

  // Sambutan dan autentikasi
  static const welcomeTitle = 'Hai! Selamat datang di RuangKelasku.';
  static const welcomeBody = 'Satu tempat untuk materi, tugas, dan nilai. Masuk atau buat akun untuk mulai.';
  static const signIn = 'Masuk';
  static const signUp = 'Buat akun';
  static const signOut = 'Keluar';
  static const name = 'Nama lengkap';
  static const email = 'Email';
  static const password = 'Kata sandi';
  static const passwordConfirm = 'Ulangi kata sandi';
  static const showPassword = 'Tampilkan kata sandi';
  static const hidePassword = 'Sembunyikan kata sandi';
  static const passwordHint = 'Minimal 8 karakter';
  static const passwordMismatch = 'Kata sandi tidak sama';
  static const invalidEmail = 'Format email tidak valid';
  static const noAccount = 'Belum punya akun?';
  static const haveAccount = 'Sudah punya akun?';
  static const signedInAs = 'Anda saat ini login sebagai';

  // Navigasi global
  static const navClasses = 'Kelas';
  static const navTodo = 'Daftar tugas';
  static const navToReview = 'Perlu diperiksa';
  static const navNotifications = 'Notifikasi';
  static const navArchived = 'Kelas yang diarsipkan';
  static const navSettings = 'Setelan';
  static const openMenu = 'Buka menu navigasi';
  static const addClass = 'Gabung atau buat kelas';

  // Beranda
  static const joinClass = 'Gabung ke kelas';
  static const createClass = 'Buat kelas';
  static const emptyClasses = 'Belum ada kelas. Gabung pakai kode dari gurumu, yuk.';
  static const invitationsTitle = 'Undangan kelas';
  static String invitedAs(String inviter, bool asTeacher) =>
      '$inviter mengundang Anda sebagai ${asTeacher ? 'pengajar' : 'siswa'}';
  static const accept = 'Terima';
  static const decline = 'Tolak';
  static String studentCount(int n) => '$n siswa';
  static String openClass(String name) => 'Buka kelas $name';

  // Gabung ke kelas
  static const classCode = 'Kode kelas';
  static const classCodeHelp = 'Mintalah kode kelas kepada pengajar, lalu masukkan kode di sini.';
  static const classCodeRules = 'Kode kelas terdiri dari 5 sampai 8 huruf atau angka, tanpa spasi atau simbol.';
  static const join = 'Gabung';
  static String joinedTitle(String name) => 'Hore, kamu sudah bergabung di $name!';
  static const openClassButton = 'Buka kelas';

  // Buat kelas
  static const className = 'Nama kelas (wajib)';
  static const section = 'Bagian';
  static const subject = 'Mata pelajaran';
  static const room = 'Ruang';
  static const theme = 'Tema';
  static const create = 'Buat';
  static const themeNames = {
    'forest': 'Hutan',
    'ocean': 'Samudra',
    'sunset': 'Senja',
    'grape': 'Anggur',
    'rose': 'Mawar',
    'lagoon': 'Laguna',
    'mango': 'Mangga',
    'slate': 'Batu',
  };

  // Menu kartu kelas dan kelas terarsip
  static const archive = 'Arsipkan';
  static const restore = 'Pulihkan';
  static const delete = 'Hapus';
  static const leaveClass = 'Batalkan pendaftaran';
  static const emptyArchived = 'Tidak ada kelas yang diarsipkan.';
  static String archiveTitle(String name) => 'Arsipkan $name?';
  static const archiveBody =
      'Kelas yang diarsipkan menjadi baca-saja: tidak ada posting, penyerahan, atau penilaian baru. Anda bisa memulihkannya kapan saja.';
  static String deleteTitle(String name) => 'Hapus $name?';
  static const deleteBody = 'Kelas ini dan semua isinya tidak akan bisa diakses lagi.';
  static String leaveTitle(String name) => 'Batalkan pendaftaran dari $name?';
  static const leaveBody = 'Anda akan dikeluarkan dari kelas ini dan tugas Anda di kelas ini ikut terhapus.';
  static const archived = 'Kelas diarsipkan';
  static const restored = 'Kelas dipulihkan';

  // Tab kelas
  static const tabStream = 'Forum';
  static const tabClasswork = 'Tugas Kelas';
  static const tabPeople = 'Anggota';
  static const tabGrades = 'Nilai';
  static const tabMyWork = 'Tugas Anda';
  static const classSettings = 'Setelan kelas';
  static const showClassCode = 'Tampilkan kode kelas';
  static const archivedBanner = 'Kelas ini diarsipkan. Semua isinya hanya bisa dibaca.';
  static const backToClasses = 'Kembali ke daftar kelas';

  // Forum
  static const shareWithClass = 'Bagikan dengan kelas Anda';
  static const announceHint = 'Umumkan sesuatu kepada kelas Anda';
  static const upcoming = 'Mendatang';
  static const upcomingEmpty = 'Tidak ada tugas yang perlu segera diselesaikan.';
  static const emptyStream = 'Belum ada posting. Di sinilah pengumuman dan tugas baru akan muncul.';
  static const seeMore = 'Lihat selengkapnya';
  static String commentCount(int n) => n == 1 ? '1 komentar kelas' : '$n komentar kelas';
  static String postedNew(String author, String type, String title) =>
      '$author memposting ${type.toLowerCase()} baru: $title';
  static const postTypeNames = {
    'announcement': 'Pengumuman',
    'material': 'Materi',
    'assignment': 'Tugas',
    'quiz': 'Tugas kuis',
    'question': 'Pertanyaan',
  };
  static const post = 'Posting';
  static const removeSchedule = 'Hapus jadwal';
  static const openAttachment = 'Buka lampiran';
  static const schedule = 'Jadwalkan';
  static const scheduledFor = 'Dijadwalkan untuk';
  static const pickDate = 'Pilih tanggal';
  static const pickTime = 'Pilih jam';
  static const posted = 'Diposting';
  static const scheduled = 'Terjadwal';
  static String scheduledAt(String date) => 'Terjadwal $date';
  static const announcementPosted = 'Pengumuman diposting';
  static const announcementScheduled = 'Pengumuman dijadwalkan';
  static const discardTitle = 'Buang perubahan?';
  static const discardBody = 'Teks yang sudah Anda tulis akan hilang.';
  static const discard = 'Buang';
  static const keepEditing = 'Lanjut menulis';

  // Tugas Kelas
  static const createAssignment = 'Tugas';
  static const createQuiz = 'Tugas kuis';
  static const createMaterial = 'Materi';
  static const createTopic = 'Topik';
  static const noTopic = 'Tanpa topik';
  static const emptyClasswork = 'Belum ada tugas atau materi di kelas ini.';
  static const emptyClassworkTeacher =
      'Belum ada apa-apa di sini. Buat tugas, kuis, atau materi pertama untuk kelas Anda.';
  static const draft = 'Draf';
  static String postedOn(String date) => 'Diposting $date';
  static String countTurnedIn(int n) => '$n diserahkan';
  static String countAssigned(int n) => '$n ditugaskan';
  static String countGraded(int n) => '$n dinilai';
  static const viewInstructions = 'Lihat petunjuk';
  static const manageTopics = 'Kelola topik';
  static const topicName = 'Nama topik';
  static const addTopic = 'Tambah topik';
  static const rename = 'Ganti nama';
  static const moveUp = 'Pindah ke atas';
  static const moveDown = 'Pindah ke bawah';
  static String deleteTopicTitle(String name) => 'Hapus topik $name?';
  static const deleteTopicBody = 'Tugas dan materi di dalamnya tetap ada dan pindah ke Tanpa topik.';
  static String deletePostTitle(String title) => 'Hapus $title?';
  static const deletePostBody = 'Nilai dan komentar yang terkait juga akan dihapus.';
  static const postDeleted = 'Posting dihapus';
  static const assignNow = 'Tugaskan sekarang';

  // Composer
  static const title = 'Judul';
  static const instructions = 'Petunjuk (opsional)';
  static const materialDescription = 'Deskripsi (opsional)';
  static const points = 'Poin';
  static const noPoints = 'Kosongkan bila tugas tanpa nilai';
  static const due = 'Tenggat';
  static const noDue = 'Tanpa tenggat';
  static const topic = 'Topik';
  static const attachments = 'Lampiran';
  static const addFile = 'Unggah file';
  static const addLink = 'Tambahkan link';
  static const takePhoto = 'Ambil foto';
  static const linkUrl = 'URL link';
  static const assign = 'Tugaskan';
  static const postMaterial = 'Posting';
  static const saveDraft = 'Simpan draf';
  static const continueToQuestions = 'Lanjut ke soal';
  static const moreActions = 'Opsi kirim lainnya';
  static const assignmentCreated = 'Tugas ditugaskan';
  static const draftSaved = 'Draf disimpan';
  static const postScheduled = 'Posting dijadwalkan';
  static String fileTooLarge(String name) => '$name lebih dari 10 MB.';
  static const forStudents = 'Untuk';
  static const allStudents = 'Semua siswa';

  // Editor soal
  static const questions = 'Soal';
  static String questionNumber(int n) => 'Soal $n';
  static const questionPrompt = 'Pertanyaan';
  static String optionLabel(int i) => 'Opsi ${String.fromCharCode(65 + i)}';
  static const correctAnswer = 'Jawaban benar';
  static const addQuestion = 'Tambah soal';
  static const addOption = 'Tambah opsi';
  static const removeQuestion = 'Hapus soal';
  static const removeOption = 'Hapus opsi';
  static const quizSaved = 'Soal disimpan';
  static const quizIncomplete = 'Lengkapi semua pertanyaan dan opsi, lalu pilih satu jawaban benar per soal.';
  static String totalPoints(int n) => 'Total $n poin';

  // Pertanyaan (stretch)
  static const createQuestion = 'Pertanyaan';
  static const questionField = 'Pertanyaan';
  static const shortAnswer = 'Jawaban singkat';
  static const multipleChoice = 'Pilihan ganda';
  static const questionKind = 'Jenis jawaban';
  static const optionsIncomplete = 'Isi semua opsi pilihan ganda.';
  static const questionPosted = 'Pertanyaan diposting';
  static const ask = 'Tanyakan';
  static const yourAnswerHint = 'Jawaban Anda';
  static const answer = 'Jawaban';
  static const answerAgain = 'Jawab lagi';
  static const notAnswered = 'Belum menjawab.';

  // Detail posting dan komentar
  static const tabInstructions = 'Petunjuk';
  static const tabStudentWork = 'Tugas siswa';
  static const classComments = 'Komentar kelas';
  static const addClassComment = 'Tambahkan komentar kelas';
  static const privateComments = 'Komentar pribadi';
  static const addPrivateComment = 'Tambahkan komentar pribadi';
  static const send = 'Kirim';
  static const noComments = 'Belum ada komentar.';
  static String pointsLabel(int n) => '$n poin';

  // Pengumpulan (siswa)
  static const yourWork = 'Tugas Anda';
  static const addOrCreate = 'Tambahkan atau buat';
  static const turnIn = 'Serahkan';
  static const unsubmit = 'Batalkan penyerahan';
  static const markAsDone = 'Tandai sebagai selesai';
  static const turnedInCheer = 'Hore, tugasmu sudah terkirim!';
  static const quizDoneCheer = 'Kuis selesai! Nilaimu akan muncul setelah dikembalikan guru.';
  static String turnedInAt(String date) => 'Diserahkan $date';
  static const startQuiz = 'Mulai kuis';
  static const reviewQuiz = 'Lihat jawaban';
  static const submitQuiz = 'Serahkan kuis';
  static const submitQuizConfirm = 'Serahkan kuis sekarang?';
  static String unansweredWarning(int n) => n == 0
      ? 'Kuis hanya bisa diserahkan sekali.'
      : 'Masih ada $n soal yang belum dijawab. Kuis hanya bisa diserahkan sekali.';
  static const yourAnswer = 'Jawaban Anda';
  static const correct = 'Benar';
  static const wrong = 'Salah';
  static String gradeOutOf(String grade, int points) => '$grade/$points';
  static const gradeReturnedCheer = 'Nilaimu sudah keluar!';

  // Penilaian (guru)
  static const returnWork = 'Kembalikan';
  static String returnSelected(int n) => 'Kembalikan ($n)';
  static String returnTitle(int n) => n == 1 ? 'Kembalikan 1 tugas?' : 'Kembalikan $n tugas?';
  static const returnBody = 'Nilai draf akan terlihat oleh siswa dan mereka mendapat notifikasi.';
  static const returned = 'Tugas dikembalikan';
  static const selectAll = 'Pilih semua';
  static const draftGrade = 'Nilai draf';
  static const saving = 'Menyimpan...';
  static const saved = 'Tersimpan';
  static const saveFailed = 'Gagal menyimpan';
  static String maxPoints(int n) => 'Nilai maksimal $n';
  static const notNumber = 'Masukkan angka';
  static const noSubmissionYet = 'Belum ada yang diserahkan.';
  static const selectStudent = 'Pilih siswa di daftar untuk melihat tugasnya.';
  static String gradeFor(String name) => 'Nilai untuk $name';

  // Anggota
  static const teachers = 'Pengajar';
  static const students = 'Siswa';
  static const inviteTeacher = 'Undang pengajar';
  static const inviteStudent = 'Undang siswa';
  static const invite = 'Undang';
  static const inviteEmailHelp = 'Undangan muncul di beranda pengguna dengan email ini.';
  static const invitationSent = 'Undangan dikirim';
  static const owner = 'Pemilik kelas';
  static const remove = 'Keluarkan';
  static String removeTitle(String name) => 'Keluarkan $name?';
  static const removeStudentBody =
      'Siswa ini kehilangan akses ke kelas, dan semua tugasnya di kelas ini ikut terhapus.';
  static const removeTeacherBody = 'Pengajar ini kehilangan akses ke kelas.';
  static const noStudents = 'Belum ada siswa. Bagikan kode kelas atau undang siswa lewat email.';
  static String memberCount(int n) => '$n orang';
  static const pendingInvitations = 'Undangan tertunda';
  static const cancelInvitation = 'Batalkan undangan';
  static String invitePageTitle(bool teacher) => teacher ? inviteTeacher : inviteStudent;

  // Daftar tugas dan Perlu diperiksa
  static const todoAssigned = 'Ditugaskan';
  static const todoMissing = 'Tidak diserahkan';
  static const todoDone = 'Selesai';
  static const allClasses = 'Semua kelas';
  static const filterClass = 'Kelas';
  static const dueGroups = {
    'noDue': 'Tanpa tenggat',
    'thisWeek': 'Minggu ini',
    'nextWeek': 'Minggu depan',
    'later': 'Nanti',
  };
  static const emptyTodoAssigned = 'Semua beres. Saatnya istirahat sebentar.';
  static const emptyTodoMissing = 'Tidak ada tugas yang terlewat. Pertahankan, ya!';
  static const emptyTodoDone = 'Belum ada tugas yang selesai.';
  static String missingWorried(int n) => 'Ada $n tugas yang terlewat. Masih bisa dikumpulkan, kok.';
  static const emptyToReview = 'Belum ada tugas untuk diperiksa.';
  static const selectItem = 'Pilih item di daftar untuk melihat detailnya.';
  static const countTurnedInLabel = 'Diserahkan';
  static const countAssignedLabel = 'Ditugaskan';
  static const countGradedLabel = 'Dinilai';

  // Tab Nilai (guru)
  static const byStudent = 'Per siswa';
  static const byAssignment = 'Per tugas';
  static const exportCsv = 'Ekspor ke CSV';
  static const exportDownloaded = 'File nilai diunduh';
  static const emptyGrades = 'Belum ada tugas yang bisa dinilai. Buat tugas atau kuis di Tugas Kelas.';
  static const draftShort = 'Draf';
  static String outOf(int points) => 'dari $points';
  static const noGradePoints = 'Tanpa nilai';
  static String gradeCellLabel(String student, String post, String value) => '$student, $post: $value';
  static const notGraded = 'Belum dinilai';

  // Tugas Anda (siswa)
  static const filterAll = 'Semua';
  static const emptyMyWork = 'Belum ada tugas di kelas ini.';
  static const emptyMyWorkFilter = 'Tidak ada tugas dengan status ini.';

  // Setelan kelas
  static const classDetails = 'Detail kelas';
  static const classDescription = 'Deskripsi kelas';
  static const general = 'Umum';
  static const inviteCode = 'Kode undangan';
  static const codeEnabled = 'Aktifkan kode kelas';
  static const codeEnabledHelp = 'Bila dinonaktifkan, siswa tidak bisa bergabung memakai kode.';
  static const resetCode = 'Reset kode';
  static const resetCodeTitle = 'Reset kode kelas?';
  static const resetCodeBody =
      'Kode lama tidak bisa dipakai lagi untuk bergabung. Siswa yang sudah bergabung tidak terpengaruh.';
  static const codeReset = 'Kode kelas direset';
  static const streamSection = 'Forum';
  static const streamPermission = 'Izin siswa';
  static const streamPermissions = {
    'all': 'Siswa dapat memposting dan berkomentar',
    'comment_only': 'Siswa hanya dapat berkomentar',
    'teacher_only': 'Hanya pengajar yang dapat memposting atau berkomentar',
  };
  static const classworkOnStream = 'Tugas Kelas di forum';
  static const classworkOnStreamOptions = {
    'show': 'Tampilkan lampiran dan detail',
    'compact': 'Tampilkan notifikasi ringkas',
    'hide': 'Sembunyikan notifikasi',
  };
  static const settingsSaved = 'Setelan disimpan';

  // Setelan profil
  static const profile = 'Profil';
  static const changePhoto = 'Ganti foto';
  static const photoTooLarge = 'Foto lebih dari 2 MB.';
  static const photoUpdated = 'Foto profil diperbarui';
  static const profileSaved = 'Profil disimpan';
  static const appearance = 'Tampilan';
  static const themeSystem = 'Ikuti sistem';
  static const themeLight = 'Terang';
  static const themeDark = 'Gelap';

  // Notifikasi
  static const emptyNotifications = 'Belum ada notifikasi.';
  static const markAllRead = 'Tandai semua sudah dibaca';
  static const unread = 'Belum dibaca';
  static String badgeCount(int n) => n > 99 ? '99+' : '$n';

  // Status submission
  static const statusLabels = {
    'assigned': 'Ditugaskan',
    'missing': 'Tidak diserahkan',
    'turned_in': 'Diserahkan',
    'graded': 'Dinilai (draf)',
    'returned': 'Dikembalikan',
  };
  static const late = 'Terlambat';

  // Pembaca layar
  static String unreadNotifications(int n) =>
      n == 0 ? 'Tidak ada notifikasi belum dibaca' : '$n notifikasi belum dibaca';
  static String avatarOf(String name) => 'Foto profil $name';
}
