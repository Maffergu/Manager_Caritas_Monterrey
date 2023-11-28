//
//  DetallesReciboView.swift
//  caritas
//
//  Created by Abigail Curiel on 18/10/23.
//

import SwiftUI

struct DetallesReciboView: View {
    @State var comentario: String = ""
    @State private var showAlert = false
    @State private var sinComentario = false
    @State private var mensajeError = ""
    @State private var regresar = false
    @State var estatus = ""
    @Environment(\.dismiss) private var dismiss
    var card: Card
    var body: some View {
        NavigationView{
            VStack {
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 430, height: 110)
                        .background(Color(red: 0, green: 0.23, blue: 0.36))
                    
                    VStack (alignment: .leading){
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "arrow.left.circle.fill")
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                    .padding(.leading, 30)
                                    .padding(.top, 45)
                            }
                            Spacer()
                        }
                    }
                    
                    VStack{
                        Text("Detalles del recibo")
                            .font(
                                Font.system(size: 24)
                                    .weight(.bold)
                                    .bold()
                                
                            )
                            .foregroundColor(.white)
                            .frame(alignment: .bottom)
                            .padding(.top, 40)
                    }
                }
                
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Recibo")
                                    .font(
                                        Font.system(size: 22)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                                var idString = String(card.ID_RECIBO)
                                Text("\(idString)")
                                    .font(
                                        Font.system(size: 25)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("Monto")
                                    .font(
                                        Font.system( size: 22)
                                            .weight(.bold)
                                    )
                                    .foregroundColor(.black)
                                    .bold()
                                
                                Text("$\(card.IMPORTE, specifier: "%.2f")")
                                    .font(
                                        Font.system(size: 25)
                                            .weight(.semibold)
                                    )
                                    .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            }
                        }
                        .padding(.top)
                        
                        Text("Nombre")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top)
                        
                        Text("\(card.NOMBRE_DONANTE)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                        
                        Text("Domicilio")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                            
                        
                        Text("\(card.DIRECCION)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .padding(.horizontal, 0.5)
                            
                        Text("Referencia de domicilio")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.5)
                        
                        Text("\(card.REFERENCIA_DOMICILIO)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                    }
                    
                    VStack(alignment: .leading){
                         
                        
                        Text("Teléfono casa")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                            
                        
                        Text("\(card.TEL_CASA)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            
                        
                        
                    }
                    VStack(alignment: .leading){
                        Text("Teléfono celular")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                            
                        Text("\(card.TEL_MOVIL)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            
                        
                    }
                    
                    VStack(alignment: .leading){
                        Text("Comentario Adicional")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                        
                        Text("\(comentario)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                        
                        Text("Estatus")
                            .font(
                                Font.system(size: 20)
                                    .weight(.bold)
                            )
                            .foregroundColor(.black)
                            .padding(.top, 0.7)
                        
                        Text("\(estatus)")
                            .font(
                                Font.system(size: 18)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                    }
                    .onAppear(){
                        changeVars()
                    }
                }
                Spacer()
            }
            
            .ignoresSafeArea()
            .padding(.horizontal, 35)
            
        }
        
    }
    
    private func changeVars() {
        if (card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0) {
            estatus = "No Pagado"
        } else if (card.ESTATUS_PAGO == 1) {
            estatus = "Pagado"
        } else {
            estatus = "No Recolectado"
        }
        
        if (card.COMENTARIOS == "") {
            comentario = "No hay comentarios adicionales"
        } else {
            comentario = card.COMENTARIOS
        }
    }
}

func validateInput(_ input: String) -> Bool {
        return !input.isEmpty
    }

struct DetallesReciboView_Previews: PreviewProvider {
    static var previews: some View {
        let card1: Card = listaCards[0]
        DetallesReciboView(card: card1)
    }
}




