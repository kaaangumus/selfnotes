#yazar emrahtolu update tarihi 28.11.2024
# GUI için gerekli bileşen
Add-Type -AssemblyName 'System.Windows.Forms'

# Grup adını almak için InputBox açma
$inputForm = New-Object System.Windows.Forms.Form
$inputForm.Text = 'Grup Adı Sorgulama'
$inputForm.Width = 400  # Pencereyi daha geniş yapalım
$inputForm.Height = 250  # Pencereyi daha uzun yapalım

# Label (Grup adı girilmesi için)
$label = New-Object System.Windows.Forms.Label
$label.Text = 'Grup Adını Giriniz:'
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,20)
$inputForm.Controls.Add($label)

# Textbox (Grup adının yazılması için)
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Width = 350  # Textbox'ı daha geniş yapalım
$textBox.Location = New-Object System.Drawing.Point(10,50)
$inputForm.Controls.Add($textBox)

# Button (Sorgulama işlemi)
$button = New-Object System.Windows.Forms.Button
$button.Text = 'Sorgula'
$button.Width = 100
$button.Location = New-Object System.Drawing.Point(10,90)
$button.Add_Click({
    $groupName = $textBox.Text

    # Grup üyelerini al (Sadece Name ve SamAccountName bilgilerini alıyoruz)
    $members = Get-ADGroupMember -Identity $groupName | Select-Object Name, SamAccountName

    # Sonuçları göster
    $members | Format-Table -AutoSize
    $members | Out-GridView

    # CSV'ye kaydetme isteği sor
    $saveToCsv = [System.Windows.Forms.MessageBox]::Show("CSV dosyasına kaydetmek ister misiniz?", "CSV Kaydet", [System.Windows.Forms.MessageBoxButtons]::YesNo)

    if ($saveToCsv -eq 'Yes') {
        $filePath = [System.Windows.Forms.SaveFileDialog]::new()
        $filePath.Filter = "CSV dosyaları (*.csv)|*.csv"
        $filePath.Title = "CSV Dosyasını Kaydet"
        
        if ($filePath.ShowDialog() -eq 'OK') {
            $members | Export-Csv -Path $filePath.FileName -NoTypeInformation
            [System.Windows.Forms.MessageBox]::Show("CSV dosyası kaydedildi.", "Başarılı")
        }
    }

    # Pencereyi kapat
    $inputForm.Close()
})

$inputForm.Controls.Add($button)

# Alt köşeye mesaj ekleme
$footerLabel = New-Object System.Windows.Forms.Label
$footerLabel.Text = "emrahtolu.com Teşekkürler."
$footerLabel.AutoSize = $true
$footerLabel.Location = New-Object System.Drawing.Point(10,180)  # Alt kısımda görünsün
$footerLabel.ForeColor = [System.Drawing.Color]::Gray  # Mesajın rengini gri yaparak daha az dikkat çekmesini sağla
$inputForm.Controls.Add($footerLabel)

# Pencereyi göster
$inputForm.ShowDialog()
