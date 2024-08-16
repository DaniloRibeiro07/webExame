get_all_cards()

function get_all_cards(){
  fetch(`${window.location.origin}/api/V1/exams`)
  .then(function (response) {
    return response.json();
  })
  .then(function (json) {
    if(json.length==0){
      document.getElementById("exams").innerHTML = "<h2>Não há exames cadastrados no sistema</h2>" 
    }else{
      document.getElementById("exams").innerHTML = ""
      json.forEach((exam) => {
        document.getElementById("exams").innerHTML += card_exam(exam)
      });
    }
  });
}

function card_exam(exam) {
  return `
    <div class="card text-center mb-3 mx-2  ${exam.token}" style="width: 18rem;" id="${exam.token}">
      <h5 class="card-header">Exame: ${exam.token} </h5>
      <div class="card-body">
        <p class="card-text"><strong>Paciente:</strong>  ${exam.patient.name} </p>
        <p class="card-text"><strong>Médico:</strong>   ${exam.doctor.name} </p>
        <p class="card-text"><strong>Data de realização:</strong>   ${new Date(exam.date).toLocaleDateString("pt-BR")} </p>
        <button class="btn btn-primary" onclick="window.search(this)" token="${exam.token}" id="button">Detalhes</button>
      </div>
    </div>
  `
}