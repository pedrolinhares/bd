# encoding: utf-8

require 'spec_helper'

feature 'adicionar objeto de aprendizagem' do
  before(:each) do
    Capybara.current_driver = :webkit
    Idioma.create! descricao: 'Português (Brasil)'
    popular_eixos_tematicos_cursos
  end

  scenario 'selecionar um curso de um eixo', javascript: true do
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'

      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'objeto_de_aprendizagem_curso_ids')
      click_button '>'

      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end

    validar_conteudo
    page.should have_content 'programação, orientação a objetos, classe'
    page.should have_content '2 meses'
    page.should have_content 'Ambiente e Saúde'
    page.should have_content 'Radiologia'
    page.should have_content 'Técnicas de programação, OO e Testes'
    page.should have_content 'Português (Brasil)'
  end

  scenario 'selecionar dois cursos de um mesmo eixo', javascript: true do
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'

      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'objeto_de_aprendizagem_curso_ids')
      click_button '>'
      select('Saneamento Ambiental', from: 'objeto_de_aprendizagem_curso_ids')
      click_button '>'

      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end

    validar_conteudo
    page.should have_content 'programação, orientação a objetos, classe'
    page.should have_content '2 meses'
    page.should have_content 'Ambiente e Saúde'
    page.should have_content 'Radiologia e Saneamento Ambiental'
    page.should have_content 'Técnicas de programação, OO e Testes'
    page.should have_content 'Português (Brasil)'
  end

  scenario 'selecionar diversos cursos de eixos diferentes', javascript: true do
    submeter_conteudo :objeto_de_aprendizagem do
      fill_in 'Palavras-chave', with: 'programação, orientação a objetos, classe'
      fill_in 'Tempo de aprendizagem típico', with: '2 meses'

      select('Ambiente e Saúde', from: 'Eixos temáticos')
      select('Radiologia', from: 'objeto_de_aprendizagem_curso_ids')
      click_button '>'
      select('Gestão Ambiental', from: 'objeto_de_aprendizagem_curso_ids')
      click_button '>'

      select('Militar', from: 'Eixos temáticos')
      select('Fotointeligência', from: 'objeto_de_aprendizagem_curso_ids')
      click_button '>'
      select('Sistemas de Armas', from: 'objeto_de_aprendizagem_curso_ids')
      click_button '>'

      fill_in 'Novas tags', with: "Técnicas de programação\nOO\nTestes"
      select 'Português (Brasil)', on: 'Idioma'
    end
    validar_conteudo
    page.should have_content 'programação, orientação a objetos, classe'
    page.should have_content '2 meses'
    page.should have_content 'Ambiente e Saúde e Militar'
    page.should have_content 'Fotointeligência, Gestão Ambiental, Radiologia e Sistemas de Armas'
    page.should have_content 'Técnicas de programação, OO e Testes'
    page.should have_content 'Português (Brasil)'
  end
end
