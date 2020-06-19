const cb = require('campeonato-brasileiro-api');

const serie = 'a';
const rodada = '10';

cb.tabela(serie).then(function(tabela) {
	console.log(tabela);
}, function(err){
	console.log(err);
});

cb.rodadaAtual(serie, rodada).then(function(rodada) {
	//console.log(rodada);
}, function(err){
	console.log(err);
});