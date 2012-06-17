#encoding: utf-8
require 'spec_helper'

feature "Formulário de contato" do
  before(:each) { ActionMailer::Base.deliveries = [] }
  scenario "envia mensagem" do
    visit formulario_contato_new_path
    fill_in 'Nome', :with => 'John Doe'
    fill_in 'Email', :with => 'john-doe@foobar.com'
    fill_in 'Assunto', :with => 'rails'
    fill_in 'Mensagem', :with => 'rails lek'
    click_button 'Enviar'
    page.body.should have_content('Obrigado por entrar em contato')
    last_email = ActionMailer::Base.deliveries.last
    last_email.to.should include('foo@bar.com')
    last_email.from.should include('john-doe@foobar.com')
  end

  scenario "não envia mensagem com campo faltando" do
    visit formulario_contato_new_path
    fill_in 'Nome', :with => 'John Doe'
    fill_in 'Assunto', :with => 'rails'
    fill_in 'Mensagem', :with => 'campo faltando lek'
    click_button 'Enviar'
    page.body.should have_content("não pode ficar em branco")
    ActionMailer::Base.deliveries.last.should == nil
  end
end
