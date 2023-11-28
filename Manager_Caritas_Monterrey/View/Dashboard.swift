//
//  Dashboard.swift
//  Caritas_Monterrey
//
//  Created by Alumno on 18/10/23.
//

import SwiftUI
import Charts
import CoreMotion

struct chartData: Identifiable {
    let id: Int
    let estatus: String
    let cantidad: Int
}

struct Dashboard: View {
    @State var listaPrueba :Array<Card> = []
    @State private var selectedFilter = 0
    @State private var selectedCollector = 0
    @State private var pagados = 0
    @State private var noPagados = 0
    @State private var noRecolectados = 0
    @State private var datas: Array<chartData> = []
    @Environment(\.dismiss) private var dismiss
    @State var xActual = 0.0
    
    let motion = CMMotionManager()
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack {
                    Image("top")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 220)
                    .clipped()
                        
                    VStack(alignment: .leading) {
                        HStack{
                            VStack (alignment: .leading){
                                Text("Bienvenido de Vuelta")
                                    .font(.system(size: 29).bold())
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Estos son los recibos de hoy")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18).bold())
                                    .opacity(0.6)
                                    
                            }
                            .padding(.trailing, 50)
                            Button {
                                dismiss()
                            } label: {
                                Image("door-exit")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .scaledToFit()
                                    .colorInvert()
                                    .padding(.top, 13)
                            }
                            .onAppear(perform: {
                                startAccelerometer()
                            })

                        }
                        .padding(.top, 10)
                        HStack {
                            VStack (alignment: .leading) {
                                Text("Ordenar por Estatus:")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .frame(width: 170, height: 40)
                                        .cornerRadius(10)
                                    HStack{
                                        
                                        Picker(selection: $selectedFilter, label: Text("Ordenar por").font(.title).bold()){
                                            Text("No Pagados").tag(2).font(.system(size: 12))
                                            Text("Pagados").tag(1).font(.system(size: 12))
                                            Text("Pendientes").tag(3).font(.system(size: 12))
                                            Text("Todos").tag(0).font(.system(size: 12))
                                        }.colorMultiply(.black).colorInvert()
                                    }
                                }
                            }
                            .padding(.trailing, 20)
                            VStack(alignment: .trailing) {
                                Text("Ordenar por Recolector:")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .padding(.bottom, -5)
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .frame(width: 170, height: 40)
                                        .cornerRadius(10)
                                    HStack{
                                        Picker(selection: $selectedCollector, label: Text("Ordenar por").font(.title).bold()){
                                            Text("ClaraRecolector").tag(1).font(.system(size: 12))
                                            Text("LaloRecolector").tag(2).font(.system(size: 12))
                                            Text("GustavoRecolector").tag(3).font(.system(size: 12))
                                            Text("MaferRecolector").tag(4).font(.system(size: 12))
                                            Text("Todos").tag(0).font(.system(size: 12))
                                        }.colorMultiply(.black).colorInvert()
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear() {
                    datas = graph()
                }
                .padding(.bottom, 10)
                Chart(datas){
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
                                .foregroundColor(Color(red: 0.38823529411764707, green: 0.8313725490196079, blue: 0.11764705882352941))
                                .frame(width: 8, height: 8)
                            Text("Pagados")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        HStack{
                            BasicChartSymbolShape.circle
                                .foregroundColor(Color(red: 1.0, green: 0.2, blue: 0.2))
                                .frame(width: 8, height: 8)
                            Text("No Pagados")
                                .foregroundColor(.black)
                                .font(.system(size: 14))
                        }
                        HStack{
                            BasicChartSymbolShape.circle
                                .foregroundColor(Color(red: 0.945, green: 0.769, blue: 0.059))
                                .frame(width: 8, height: 8)
                            Text("Pendientes")
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
                            range: [Color(red: 0.388, green: 0.831, blue: 0.117), Color(red: 1.0, green: 0.2, blue: 0.2), Color(red: 0.945, green: 0.769, blue: 0.059)]
                        )
                VStack {
                    List(listaPrueba) { cardItem in
                        if (cardItem.USUARIO_RECOLECTOR == "ClaraRecolector") {
                            if (cardItem.FECHA_PAGO == "" && cardItem.ESTATUS_PAGO != 1) {
                                //morado, pendientes
                                if((selectedFilter == 0 || selectedFilter == 3) && (selectedCollector == 0 || selectedCollector == 1)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            } else if (cardItem.ESTATUS_PAGO == 1) {
                                //verde, pagados
                                if((selectedFilter == 0 || selectedFilter == 1) && (selectedCollector == 0 || selectedCollector == 1)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                                
                            } else {
                                if((selectedFilter == 0 || selectedFilter == 2) && (selectedCollector == 0 || selectedCollector == 1)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            }
                        }
                        if (cardItem.USUARIO_RECOLECTOR == "LaloRecolector") {
                            if (cardItem.FECHA_PAGO == "" && cardItem.ESTATUS_PAGO != 1) {
                                //morado, pendientes
                                if((selectedFilter == 0 || selectedFilter == 3) && (selectedCollector == 0 || selectedCollector == 2)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            } else if (cardItem.ESTATUS_PAGO == 1) {
                                //verde, pagados
                                if((selectedFilter == 0 || selectedFilter == 1) && (selectedCollector == 0 || selectedCollector == 2)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                                
                            } else {
                                if((selectedFilter == 0 || selectedFilter == 2) && (selectedCollector == 0 || selectedCollector == 2)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            }
                        }
                        if (cardItem.USUARIO_RECOLECTOR == "GustavoRecolector") {
                            if (cardItem.FECHA_PAGO == "" && cardItem.ESTATUS_PAGO != 1) {
                                //morado, pendientes
                                if((selectedFilter == 0 || selectedFilter == 3) && (selectedCollector == 0 || selectedCollector == 3)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            } else if (cardItem.ESTATUS_PAGO == 1) {
                                //verde, pagados
                                if((selectedFilter == 0 || selectedFilter == 1) && (selectedCollector == 0 || selectedCollector == 3)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                                
                            } else {
                                if((selectedFilter == 0 || selectedFilter == 2) && (selectedCollector == 0 || selectedCollector == 3)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            }
                        }
                        if (cardItem.USUARIO_RECOLECTOR == "MaferRecolector") {
                            if (cardItem.FECHA_PAGO == "" && cardItem.ESTATUS_PAGO != 1) {
                                //morado, pendientes
                                if((selectedFilter == 0 || selectedFilter == 3) && (selectedCollector == 0 || selectedCollector == 4)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            } else if (cardItem.ESTATUS_PAGO == 1) {
                                //verde, pagados
                                if((selectedFilter == 0 || selectedFilter == 1) && (selectedCollector == 0 || selectedCollector == 4)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                                
                            } else {
                                if((selectedFilter == 0 || selectedFilter == 2) && (selectedCollector == 0 || selectedCollector == 4)){
                                    NavigationLink {
                                        DetallesReciboView(card: cardItem).navigationBarBackButtonHidden()
                                    } label: {
                                        Cards(card: cardItem)
                                    }
                                }
                            }
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
        noPagados = 0
        pagados = 0
        noRecolectados = 0
        for card in listaPrueba {
            if (selectedCollector == 0) {
                if (card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0) {
                    noPagados = noPagados + 1
                } else if (card.ESTATUS_PAGO == 1) {
                    pagados = pagados + 1
                } else {
                    noRecolectados = noRecolectados + 1
                }
            } else if (selectedCollector == 1) {
                if (card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0 && card.USUARIO_RECOLECTOR == "ClaraRecolector") {
                    noPagados = noPagados + 1
                } else if (card.ESTATUS_PAGO == 1 && card.USUARIO_RECOLECTOR == "ClaraRecolector") {
                    pagados = pagados + 1
                } else if (card.USUARIO_RECOLECTOR == "ClaraRecolector"){
                    noRecolectados = noRecolectados + 1
                }
            } else if (selectedCollector == 2) {
                if (card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0 && card.USUARIO_RECOLECTOR == "LaloRecolector") {
                    noPagados = noPagados + 1
                } else if (card.ESTATUS_PAGO == 1 && card.USUARIO_RECOLECTOR == "LaloRecolector") {
                    pagados = pagados + 1
                } else if (card.USUARIO_RECOLECTOR == "LaloRecolector"){
                    noRecolectados = noRecolectados + 1
                }
            } else if (selectedCollector == 3) {
                if (card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0 && card.USUARIO_RECOLECTOR == "GustavoRecolector") {
                    noPagados = noPagados + 1
                } else if (card.ESTATUS_PAGO == 1 && card.USUARIO_RECOLECTOR == "GustavoRecolector") {
                    pagados = pagados + 1
                } else if (card.USUARIO_RECOLECTOR == "GustavoRecolector"){
                    noRecolectados = noRecolectados + 1
                }
            } else if (selectedCollector == 4) {
                if (card.FECHA_PAGO != "" && card.ESTATUS_PAGO == 0 && card.USUARIO_RECOLECTOR == "MaferRecolector") {
                    noPagados = noPagados + 1
                }   else if (card.ESTATUS_PAGO == 1 && card.USUARIO_RECOLECTOR == "MaferRecolector") {
                    pagados = pagados + 1
                } else if (card.USUARIO_RECOLECTOR == "MaferRecolector"){
                    noRecolectados = noRecolectados + 1
                }
            }
        }
        let data: [chartData] = [
            chartData(id: 1, estatus: "Pagado", cantidad: pagados),
            chartData(id: 2, estatus: "No Pagados", cantidad: noPagados),
            chartData(id: 3, estatus: "No Recolectados", cantidad: noRecolectados)
        ]
        print(data)
        return data
    }
    
    func startAccelerometer(){
        if (motion.isAccelerometerAvailable){
            //Sensar cada 0.5 segundos
            motion.deviceMotionUpdateInterval = 0.5
            
            //Iniciar el "escuchar" el acelerometro
            motion.startDeviceMotionUpdates(to: .main) { data, error in
                if let data = data {
                    datas = graph()
                    xActual = data.userAcceleration.x
                    
                    if (abs(xActual) > 1) {
                        selectedFilter = 0
                        selectedCollector = 0
                    }
                }
            }
        }
    }
}



struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}


