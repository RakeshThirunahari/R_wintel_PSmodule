$ie = New-Object -ComObject "internetExplorer.Application"
$ie.Visible =$true
$ie.Navigate("https://esls2.eu.smi.ibm.com/maximo/ui/?event=loadapp&value=incident&uisessionid=3926&csrftoken=6afhaiemts0iq9d3bco31f5mrm")


$ie.Document.getElementById("j_username").value = "thrakesh@in.ibm.com"
$ie.Document.getElementById("j_password").value = "Rakesh@ibm++"
$ie.Document.getElementById("loginbutton").click()

$page = $ie.Document
#incidents owned by my group
$page.getElementById("m9e1854a7_ns_menu_queryMenuItem_11_a_tnode").click()
$page.getElementById("m6a7dfd2f_tfrow_[C:7]_txt-tb").value = '1'
$page.getElementById("m6a7dfd2f-ti2_img").click()
$page.getElementById("m6a7dfd2f_tdrow_[C:1]_ttxt-lb[R:1]").lable

$cred = @{ j_username = "thrakesh@in.ibm.com"
j_password = "Rakesh@ibm++" }
$test=Invoke-WebRequest -Uri "https://esls2.eu.smi.ibm.com/maximo/ui/?event=loadapp&value=incident&uisessionid=3926&csrftoken=6afhaiemts0iq9d3bco31f5mrm" -Method Post -Body $cred


m6a7dfd2f_tbod-tbd
