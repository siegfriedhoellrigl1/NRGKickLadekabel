<html><body><h1>Ladekabel</h1>
 <meta http-equiv="Pragma" content="no-cache">
 <head>
  <style>
   h1 {
    font-size:2vw;
   }
   * {
    font-size:3vw;

     }
   a {
     font-size: 8vw;
     text-decoration: none;
     background-color: #EEEEEE;
     color: #333333;
     padding: 2px 6px 2px 6px;
     border-top: 1px solid #CCCCCC;
     border-right: 1px solid #333333;
     border-bottom: 1px solid #333333;
     border-left: 1px solid #CCCCCC;
   }
  </style>

  <title>Ladekabel</title>
  <link rel="shortcut icon" type="image/x-icon" href="favicon.ico" />
 </head>
<hr>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="-1">



<?php
 $IP=$_SERVER['REMOTE_ADDR'];
>

<?php

if (isset($_POST['sliderValue']))
{ $strom = $_POST['sliderValue'];
  $x=shell_exec("/www/ladekabel.sh ".$strom." \"".$wer."\"| awk '{printf(\"%s<br>\\\n\",$0);}'");
}
else
 $x=shell_exec("/www/ladekabel.sh | awk '{printf(\"%s<br>\\\n\",$0);}' 2>&1");


preg_match("/Ladestrom (.*)A/",$x,$y); $imax=preg_replace("/[^\d]/","",$y[1]);


 echo $x;

?>




<!DOCTYPE html>
<html lang="de">
<body>
    <div class="slider-container">
        <label for="mySlider">Wert: <span id="sliderValue"><?php echo $imax;?></span></label>
        <input type="range" id="mySlider" min="0" max="16" value="<?php echo $imax;?>">
    </div>

    <!-- Verstecktes Formular -->
    <form id="sliderForm" method="POST" action="index.php">
        <input type="hidden" id="sliderInput" name="sliderValue" value="<?php echo $imax;?>">
    </form>

    <script src="script.js"></script>
</body>
</html>

<script>
// Das Slider-Element und das Textfeld zum Anzeigen des Werts abrufen
const slider = document.getElementById('mySlider');
const sliderValue = document.getElementById('sliderValue');
const sliderInput = document.getElementById('sliderInput');
const sliderForm = document.getElementById('sliderForm');

// Funktion zum Aktualisieren des angezeigten Werts
slider.addEventListener('input', function() {
    sliderValue.textContent = slider.value;
});

// Funktion, die beim Loslassen des Sliders aufgerufen wird
slider.addEventListener('change', function() {
    // Setzt den Wert im versteckten Eingabefeld
    sliderInput.value = slider.value;

    // Formular absenden (Seite wird neu geladen)
    sliderForm.submit();
});


</script>

<td><a href=".">Refresh</a></td>

