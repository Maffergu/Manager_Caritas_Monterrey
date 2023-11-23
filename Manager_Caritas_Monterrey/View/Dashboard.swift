//
//  Dashboard.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI
import Charts

struct chartData: Identifiable {
    let id: Int
    let estatus: String
    let cantidad: Int
}

struct Dashboard: View {
    @State var listaPrueba :Array<Card> = []
    @State private var selectedFilter = 0
    @State private var pagados = 0
    @State private var noPagados = 0
    @State private var noRecolectados = 0
    @State private var data: Array<chartData> = []
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    Image("top")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 435, height: 191)
                    .clipped()
                        
                    VStack(alignment: .leading) {
                        HStack{
                            VStack{
                                Text("Bienvenido de Vuelta")
                                    .font(.system(size: 29).bold())
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 60)
                                    .padding(.top, 30)
                                
                                Text("Estas son las recolecciones de hoy")
                                    .font(.system(size: 19))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white.opacity(0.5))
                                    .padding(.trailing, 30)
                            }
                            
                            
                            NavigationLink(destination: ContentView()) {
                                
                                            Image("door-exit")
                                                .resizable(resizingMode: .stretch)
                                                .frame(width: 30, height: 30)
                                                .colorInvert()
                                                .padding(.top, 15)
                                                .padding(.leading, -28)
                                        }
                                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                        .navigationBarHidden(true)
                            
                        }
                        
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color.white.opacity(0.5))
                                .frame(width: 173, height: 40)
                                .cornerRadius(10)
                            HStack{
                               
                                Picker(selection: $selectedFilter, label: Text("Ordenar por").font(.title).bold()){
                                    Text("No Pagados").tag(2).font(.system(size: 12))
                                    Text("Pagados").tag(1).font(.system(size: 12))
                                    Text(" Pendientes").tag(3).font(.system(size: 12))
                                    Text("Todos").tag(0).font(.system(size: 12))
                                }.colorMultiply(.black).colorInvert()
                                //.colorMultiply(.black)
                            }
                        }.scaleEffect(0.8)
                            .offset(x: -75, y: -5)
                            //.padding(.top, -19)
                            .padding(.leading, -11)
                            //.pickerStyle(.segmented)
                            .frame(width: 300)
                    }
                }
                .onAppear() {
                    data = graph()
                }
                .padding(.bottom, 10)
                Chart(data){
                    BarMark(
                        x: .value("Cantidad", $0.cantidad)
                    )
                    .foregroundStyle(by: .value("Estatus", $0.estatus))
                    .position(by: .value("Estatus", $0.estatus))
                }
                .chartLegend(position: .top, alignment: .center) {
                    HStack {
                        HStack{
                            BasicChartSymbolShape.circle
                                .foregroundColor(Color(red: 0.180, green: 0.8, blue: 0.443))
                                .frame(width: 8, height: 8)
                            Text("Pagados")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        HStack{
                            BasicChartSymbolShape.circle
                                .foregroundColor(Color(red: 0.906, green: 0.298, blue: 0.235))
                                .frame(width: 8, height: 8)
                            Text("No Pagados")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        HStack{
                            BasicChartSymbolShape.circle
                                .foregroundColor(Color(red: 0.945, green: 0.769, blue: 0.059))
                                .frame(width: 8, height: 8)
                            Text("No Recolectados")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    }
                }
                .chartPlotStyle { charContent in
                    charContent
                        .frame(width: 250, height: 32)
                        .padding(.bottom, 30)
                }
                .chartForegroundStyleScale(
                            range: [Color(red: 0.18, green: 0.8, blue: 0.443), Color(red: 0.906, green: 0.298, blue: 0.235), Color(red: 0.945, green: 0.769, blue: 0.059)]
                        )
                VStack {
                    List(listaPrueba) { cardItem in
                        NavigationLink {
                            DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                        } label: {
                            Cards(card: cardItem)
                        }
                    }
                    .listStyle(.plain)
                    .padding(.top, 20)
                }
                .padding(.top, -50)
                .onAppear(){
                    listaPrueba = callApi()
                }
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
    
    private func graph() -> Array<chartData> {
        for card in listaPrueba {
            if (card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0) {
                noPagados = noPagados + 1
            } else if (card.ESTATUS_PAGO == 1) {
                pagados = pagados + 1
            } else {
                noRecolectados = noRecolectados + 1
            }
        }
        let data: [chartData] = [
            chartData(id: 1, estatus: "Pagado", cantidad: pagados),
            chartData(id: 2, estatus: "No Pagados", cantidad: noPagados),
            chartData(id: 3, estatus: "No Recolectados", cantidad: noRecolectados)
        ]
        return data
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}


