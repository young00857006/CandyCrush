//
//  ContentView.swift
//  Crush
//
//  Created by tingyang on 2022/4/29.
//

import SwiftUI

struct Data: Identifiable{
    let id = UUID()
    var name: Int
}

struct ContentView: View {
    
    @State private var datas = [Data]()
    @State private var startDetectDrag = false
    @State private var temp = Int()
    func initial(){
        datas.removeAll()
        for i in 1...25{
            datas.append(Data(name: Int.random(in: 1..<7)))
        }
        
    }
   
    func exRight(index:Int){
        temp = datas[index].name
        if(index%5 < 4){
            datas[index].name = datas[index+1].name
            datas[index+1].name = temp
        }
    }
    
    func exLeft(index:Int){
        temp = datas[index].name
        if(index%5 > 0){
            datas[index].name = datas[index-1].name
            datas[index-1].name = temp
        }
    }
    func exDown(index:Int){
        temp = datas[index].name
        if(index < 20){
            datas[index].name = datas[index+5].name
            datas[index+5].name = temp
        }
    }
    
    func exUp(index:Int){
        temp = datas[index].name
        if(index > 4){
            datas[index].name = datas[index-5].name
            datas[index-5].name = temp
        }
    }
    
    var body: some View {
        Button("start"){
            initial()
        }
        VStack{
        let columns = Array(repeating: GridItem(), count: 5)
        LazyVGrid(columns: columns) {
            ForEach(Array(datas.enumerated()), id: \.element.id) { index, data in
                Rectangle()
                    .opacity(0.7)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image("\(data.name)")
                            .resizable()
                            .scaledToFill()
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged({ value in
                                        if startDetectDrag {
                                            if value.translation.width > 5 {
                                                exRight(index: index)
                                                startDetectDrag = false
                                            }
                                            else if value.translation.width < -5 {
                                                exLeft(index: index)
                                                startDetectDrag = false
                                            }
                                            else if value.translation.height > 5 {
                                                exDown(index: index)
                                                startDetectDrag = false
                                            }
                                            else if value.translation.height < -5 {
                                                exUp(index: index)
                                                startDetectDrag = false
                                            }
                                        }
                                        else {
                                            if value.translation == .zero {
                                                startDetectDrag = true
                                            }
                                        }
                                    })
                            )
                    )
                    .clipped()
                    
            }
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
