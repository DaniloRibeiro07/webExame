document.getElementById("form-search").addEventListener("submit", function(event){
  event.preventDefault()
});

function search(element){
  let token
  if(element.getAttribute("token")){
    token = element.getAttribute("token")
  }else{
    token = element.search_input.value
    if (token === "") return;
  }

  fetch(`${window.location.origin}/api/V1/exam/${token}`)
  .then(function (response) {
    return response.json();
  })
  .then(function (json) {
    if(Object.keys(json).length === 0){
      document.getElementById("exams").innerHTML =
      `
      <h1>Exame com o Token ${token} não encontrado</h1>
      `
    }else{
      document.getElementById("exams").innerHTML = detail_exam(json)
    }
    
  });
}

function detail_exam(exam){
  let main_body =  `
  <div class="container">

    <hr/>

    <div class="row" id="patient-doctor">
      <div class="col" id="patient">
        <h2>Paciente</h2>
        <h4><strong>Nome completo:</strong> ${exam.patient.name}</h4>
        <h4><strong>Email:</strong> ${exam.patient.email} </h4>
        <h4><strong>Data de nascimento:</strong> ${new Date(exam.patient.date_of_birth).toLocaleDateString("pt-BR")} </h4>
        <h4><strong>Cidade/Estado:</strong> ${exam.patient.city}/${exam.patient.state} </h4>
      </div>
      <div class="col" id="doctor">
        <h2>Médico Solicitante</h2>
        <h4><strong>Nome completo:</strong> ${exam.doctor.name} </h4>
        <h4><strong>Email:</strong> ${exam.doctor.email} </h4>
        <h4><strong>CRM:</strong> ${exam.doctor.crm} - ${exam.doctor.crm_state} </h4>
      </div>
    </div>

    <hr/>

    <div class="row text-center">
      <h2>Exame</h2>
      <div class="col">
        <h4><strong>Token:</strong> ${exam.token} </h4>
      </div>
      
      <div class="col">
        <h4><strong>Data de realização:</strong> ${new Date(exam.date).toLocaleDateString("pt-BR")} </h4>
      </div>
    </div>

    <hr/>

    <div class="row text-center">
      <h2>Resultados</h2>
    </div>


    <div class="row text-center">
      <div class="col">
        <h4><strong>Tipo de exame</strong></h4>
      </div>

      <div class="col">
        <h4><strong>Resultado</strong></h4>
      </div>

      <div class="col">
        <h4><strong>Limites</strong> </h4>
      </div>
    </div>
  `

  exam.exam_result.forEach(result => {
    main_body +=
    `
      <div class="row text-center">
        <div class="col">
          <h4> ${result.type} </h4>
        </div>

        <div class="col">
          <h4> ${result.result_type} </h4>
        </div>

        <div class="col">
          <h4> ${result.limit_exam} </h4>
        </div>
      </div>
    `
  });
  
  main_body += '</div>'
  return main_body
}