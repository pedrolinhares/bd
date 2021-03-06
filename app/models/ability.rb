# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(usuario)

    usuario ||= Usuario.new    # usuário não cadastrado (convidado)

    if usuario.gestor? || usuario.contribuidor?
      can [:ter_escrivaninha, :ter_estante], Usuario
    end

    if usuario.contribuidor?
      instituicao = usuario.campus.instituicao.nome
      unless instituicao == 'Não pertenço a uma Instituição da Rede Federal de EPCT'
        can [:adicionar_conteudo], Usuario
      end
      can [:read, :edit, :update], Conteudo do |conteudo|
        !conteudo.recolhido?
      end
      can [:create, :submeter], Conteudo
      can [:destroy], Conteudo do |conteudo|
        conteudo.editavel? && conteudo.contribuidor_id == usuario.id
      end
    end

    if usuario.gestor?
      can [:read, :edit, :update], Conteudo
      can :aprovar, Conteudo do |conteudo|
        usuario.pode_aprovar? conteudo
      end
      can :recolher, Conteudo do |conteudo|
        usuario.pode_recolher?(conteudo) &&
        (conteudo.pendente? || conteudo.publicado?)
      end
      can :devolver, Conteudo do |conteudo|
        usuario.pode_devolver?(conteudo) && conteudo.pendente?
      end
      can :retornar_para_revisao, Conteudo do |conteudo|
        usuario.mesma_instituicao? conteudo
      end
      can [:lista_de_revisao, :ter_lista_de_revisao], Usuario
    end

    if usuario.admin?
      can [:atualizar_papeis, :index, :buscar_por_nome, :usuarios_instituicao, :papeis], Usuario
    end

    if usuario.instituicao_admin?
      can [:atualizar_papeis, :index, :buscar_por_nome, :papeis], Usuario
    end

    can [:area_privada, :escrivaninha, :estante, :minhas_buscas], Usuario, { :id => usuario.id }
    can [:favoritar, :remover_favorito], Conteudo
    can [:favoritar], Grao
  end
end
