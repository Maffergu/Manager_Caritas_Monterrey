//
//  Cards.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI

struct Cards: View {
    @State private var squareBg = Color(red: 161/255, green: 90/255, blue: 149/255)
    @State private var comentario = ""
    var card: Card
    var body: some View {
        HStack{
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 19, height: 151)
            .background(squareBg)
            .onAppear(perform: {
                changeBg()
            })
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Recibo")
                            .font(.system(size:25).bold())
                        Text("\(card.ID_RECIBO)")
                            .font(.system(size: 20).bold())
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Monto")
                            .font(.system(size:25).bold())
                        Text("$\(card.IMPORTE, specifier: "%.2f")")
                            .font(.system(size: 20).bold())
                            .foregroundColor(Color(red: 0, green: 0.23, blue: 0.36))
                            .multilineTextAlignment(.trailing)
                    }
                    .padding(.trailing, 10)
                }
                HStack {
                    Text("Recolector: \(card.USUARIO_RECOLECTOR)")
                        .font(.system(size:20).bold())
                    Spacer()
                }
                HStack {
                    Text("Comentario: \(comentario)")
                        .font(.system(size:20).bold())
                    Spacer()
                }
            }
        }
        .frame(width: 357, height: 151)
        .background(Color.white.shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4))
        
    }
    
    private func changeBg() {
        if card.ESTATUS_PAGO == 1 {
            squareBg = Color(red: 0, green: 0.5, blue: 0)
        }
        if card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0 {
            squareBg = Color(red: 1, green: 0.5, blue: 0.2)
        }
        if card.COMENTARIOS == "" {
            comentario = "Sin Comentario"
        } else {
            comentario = card.COMENTARIOS
        }
        
    }
}

struct Cards_Previews: PreviewProvider {
    static var previews: some View {
        let card1: Card = listaCards[0]
        Cards(card: card1)
    }
}

