require 'rspec'
require_relative '../lib/prototyped_object'

describe PrototypedObject do

  # parte 1

  let :objeto do
    PrototypedObject.new
  end

  context 'set_property' do
    it 'permite definir una nueva propiedad' do
      objeto.set_property(:nueva_propiedad, 100)
      expect(objeto.nueva_propiedad).to eq(100)
      expect(objeto.nueva_propiedad = 200).to eq(200)
    end
    it 'arroja excepcion si no se le asigno la propiedad' do
      expect{objeto.nueva_propiedad}.to raise_error NoMethodError
      expect{objeto.nueva_propiedad = 350}.to raise_error NoMethodError
    end
  end

  context 'set_method' do
    it 'permite definir un nuevo metodo' do
      objeto.set_method(:nombre_metodo, proc {2})
      expect(objeto.nombre_metodo).to eq(2)
    end
    it 'arroja excepcion si no se le asigno el metodo' do
      expect{objeto.nombre_motodo}.to raise_error NoMethodError
    end
  end

  context 'set' do
    it 'permite definir un metodo o propiedad indistintamente' do
      objeto.set(:nueva_propiedad, 15)
      expect(objeto.nueva_propiedad).to eq(15)
      objeto.set(:nuevo_proc, proc { 320 + 1 })
      expect(objeto.nuevo_proc).to eq(321)
      objeto.set(:nuevo_metodo) { 670 + 8 }
      expect(objeto.nuevo_metodo).to eq(678)
    end
    it 'arroja excepcion si no se le asigna un metodo o propiedad' do
      expect{objeto.set(:metodo_o_propiedad)}.to raise_error
    end
  end

  # parte 2

  let :padre do
    PrototypedObject.new
  end
  let :hijo do
    obj = PrototypedObject.new
    obj.set_prototype(padre)
    obj
  end

  context 'un objeto' do
    it 'posee las propiedades de su prototipo' do
      padre.set_property :propiedad, 100
      expect(hijo.propiedad).to eq 100
    end
    it 'posee los metodos de su prototipo' do
      padre.set_method :metodo, proc{ 100 }
      expect(hijo.metodo).to eq 100
    end
    it 'no posee las propiedades de sus hijos' do
      hijo.set_property :propiedad, proc{ 100 }
      expect{padre.propiedad}.to raise_error NoMethodError
    end
    it 'no posee los metodos de sus hijos' do
      hijo.set_method :metodo, proc{ 100 }
      expect{padre.metodo}.to raise_error NoMethodError
    end
  end

  # tests de integracion

  it 'prototipos programaticos - parte 1' do
    guerrero = PrototypedObject.new

    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)

  end

end