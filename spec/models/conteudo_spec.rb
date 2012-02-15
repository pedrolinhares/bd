require 'spec_helper'

describe Conteudo do
  it 'nao pode possuir simultaneamente arquivo e link' do
    Factory.build(:conteudo, arquivo: 'arquivo.nsi', link: '').should be_valid
    Factory.build(:conteudo, arquivo: '', link: 'http://nsi.iff.edu.br').
      should be_valid
    conteudo = Factory.build(:conteudo, arquivo: 'arquivo.nsi',
                                        link: 'http://nsi.iff.edu.br')
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
    conteudo.errors[:link].should be_any
  end

  it 'arquivo ou link devem existir' do
    conteudo = Factory.build(:conteudo, arquivo: '', link: '')
    conteudo.should_not be_valid
    conteudo.errors[:arquivo].should be_any
    conteudo.errors[:link].should be_any
  end

  it 'area deve ser a area ligada a sua subarea' do
    area = Factory.create(:area)
    subarea = Factory.create(:sub_area, area: area)
    conteudo = Factory.build(:conteudo, sub_area: subarea)

    conteudo.area.should be(area)
  end

  context 'atributos obrigatorios' do
    it { should_not have_valid(:titulo).when('', nil) }
    it { should_not have_valid(:sub_area).when(nil) }
    it { should_not have_valid(:campus).when('', nil) }

    it 'deve ter pelo menos um autor' do
      subject.valid?
      subject.errors[:autores].should be_any
      subject.autores.build(nome: 'Linus', lattes: 'http://lattes.cnpq.br/1')
      subject.valid?
      subject.errors[:autores].should_not be_any
    end
  end
end
