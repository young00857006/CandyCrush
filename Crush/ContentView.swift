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
    var rotateDegree = 0.0
}

struct ContentView: View {
    
    @State private var datas = [Data]()
    @State private var startDetectDrag = false
    @State private var temp = Int()
    @State private var enabled = false
    @State private var arr = [Int]()
    @State private var exTemp = Int()
    @State private var correct = false
    
    
    func initial(){
        datas.removeAll()
        for _ in 1...25{
            datas.append(Data(name: Int.random(in: 1..<7)))
        }
        
    }
   
    func exRight(index:Int){
        temp = datas[index].name
        if(index%5 < 4){
            datas[index].name = datas[index+1].name
            datas[index+1].name = temp
            enabled.toggle()
        }
    }
    
    func exLeft(index:Int){
        temp = datas[index].name
        if(index%5 > 0){
            datas[index].name = datas[index-1].name
            datas[index-1].name = temp
            enabled.toggle()
        }
    }
    func exDown(index:Int){
        temp = datas[index].name
        if(index < 20){
            datas[index].name = datas[index+5].name
            datas[index+5].name = temp
            enabled.toggle()
        }
    }
    
    func exUp(index:Int){
        temp = datas[index].name
        if(index > 4){
            datas[index].name = datas[index-5].name
            datas[index-5].name = temp
            enabled.toggle()
        }
    }
    
    func check()->Bool{
        if(arr.isEmpty){
            return true
        }
        else{
            return false
        }
    }
    
    func judge(){
        arr.removeAll()
        //vertical
        for i in 0..<20{
            var index = i + 5
            var temp = 1
            while(index < 25){
                if(datas[i].name == datas[index].name){
                    temp += 1
                    index += 5
                }
                else{
                    break
                }
            }
            if(temp > 2){
                for i in stride(from: i, to: index, by: 5){
                    var have = false
                    for j in arr {
                        if(j == i){
                            have = true
                            break
                        }
                    }
                    if(!have){
                        arr.append(i)
                    }
                }
            }
        }
        
        //horizontal
        for i in 0..<23{
            if(i%5 < 3){
                var index = i + 1
                var temp = 1
                while(index%5 > i%5 && i < 25){
                    if(datas[i].name == datas[index].name){
                        temp += 1
                        index += 1
                    }
                    else{
                        break
                    }
                }
                if(temp > 2){
                    for i in stride(from: i, to: index, by: 1){
                        var have = false
                        for j in arr {
                            if(j == i){
                                have = true
                                break
                            }
                        }
                        if(!have){
                            arr.append(i)
                        }
                    }
                }
            }
        }
        print(arr)
    }
    func Correct(){
        
        for i in arr{
            datas[i].rotateDegree = 360
            correct.toggle()
        }
    }
    func generate(){
            for i in arr{
                datas[i].rotateDegree = 0
                datas[i].name = Int.random(in: 1..<7)
            }
    }
    
    func test(){
        print("------")
        judge()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            Correct()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("1")
                generate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    print("2")
                    judge()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                        if(!check()){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                test()
                            }
                        }
                    }
                }
                
            }
        }
    }
    var body: some View {
        Button("Random"){
            initial()
            test()
        }
        
        VStack{
            let columns = Array(repeating: GridItem(), count: 5)
            LazyVGrid(columns: columns) {
                ForEach(Array(datas.enumerated()), id: \.element.id) { index, data in
                    Rectangle()
                        .aspectRatio(1, contentMode: .fit)
                        .opacity(0.7)
                        
                        .overlay(
                            Image("\(data.name)")
                                .resizable()
                                .scaledToFill()
                                .rotationEffect(.degrees(data.rotateDegree))
                                .animation(.easeInOut.delay(1), value: correct)
                                .animation(.spring(dampingFraction: 0.5).speed(2), value: enabled)
//                                .animation(.spring(dampingFraction: 0.1).speed(2).delay(10), value: correct)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged({ value in
                                            if startDetectDrag {
                                                if value.translation.width > 5 {
                                                    exTemp = 0
                                                    exRight(index: index)
                                                    startDetectDrag = false
                                                }
                                                else if value.translation.width < -5 {
                                                   exTemp = 1
                                                    exLeft(index: index)
                                                    startDetectDrag = false
                                                }
                                                else if value.translation.height > 5 {
                                                    exTemp = 2
                                                    exDown(index: index)
                                                    startDetectDrag = false
                                                }
                                                else if value.translation.height < -5 {
                                                    exTemp = 3
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
                                        .onEnded{  _ in
                                            judge()
                                            if(check()){
                                                if(exTemp == 0){
                                                    exRight(index: index)
                                                    startDetectDrag = false
                                                }
                                                else if(exTemp == 1){
                                                    exLeft(index: index)
                                                    startDetectDrag = false
                                                }
                                                else if(exTemp == 2){
                                                    exDown(index: index)
                                                    startDetectDrag = false
                                                }
                                                else if(exTemp == 3){
                                                    exUp(index: index)
                                                    startDetectDrag = false
                                                }
                                            }
                                           test()
                                        }
                                )
                           
                        )
                        .clipped()
                }
            }
        }
//        .animation(.spring(dampingFraction: 0.1).speed(2),value: enabled)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
