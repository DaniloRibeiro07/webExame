function renderHtmlUpload(){
  document.getElementById("exams").innerHTML = 
  `
  <div class="container">
    <h1>Importar arquivo CSV de Exames</h1>
    <form id="form-uploadCSV" onsubmit="uploadCSV(this)">
      <label for="file_csv">Selecione o arquivo CSV com os dados de exame</label>
      <input type="file" id="file_csv" name="avatar" accept="text/csv" required/>
      <input type="submit" value="Enviar">
    </form>
  </div>
  `
  document.getElementById("form-uploadCSV").addEventListener("submit", function(event){
    event.preventDefault()
  });
}

function uploadCSV(element){
  file = element.file_csv.files[0]

  let reader = new FileReader();
  reader.readAsText(file, "UTF-8");
  reader.onload = function (evt) {
    document.getElementById("exams").innerHTML = 
    `
    <div class="container">
      <h1>Importar arquivo CSV de Exames</h1>
      <h4>Upload em processamento...</h4>
      <h4>Retornando a listagem de todos os exames...</h4>
    </div>
    `
    fetch(`${window.location.origin}/uploadCSV`, {
      method: 'POST',
      headers: {
        'Content-Type': 'text/csv'
      },
      body: evt.target.result
    })
    .then((response)=>{
      setTimeout(()=>{get_all_cards()}, 10000)
    })
  }
}

