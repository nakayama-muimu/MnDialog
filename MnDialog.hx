import js.lib.Function;
import js.Browser.document;

@:expose
@:keep


class MnDialog{
    var divBG:js.html.DivElement;
    var divBase:js.html.DivElement;
    var divTitle:js.html.DivElement;
    var divBody:js.html.DivElement;
    var divButtons:js.html.DivElement;
    var button1:js.html.ButtonElement;
    var button2:js.html.ButtonElement;
    var button3:js.html.ButtonElement;
    var colorTitle:String = "#9999ff";
    var colorTitleText = "#ffffff";
    var colorButton:String = "#6666ff";
    var colorBase:String = "#eeeeff";
    var cssPrefix:String;
    var id:String = '';
    var width:Int;
    var height:Int;
    var cbButton:js.lib.Function;

    public function new(width:Int = 250, height:Int = 150, id:String, cssPrefix:String){
        // 引数の処理
        // オブジェクトのid
        if(id != null){
            this.id = id;
        }
        // cssのプレフィックス（styleタグのidとしても使用）
        if(cssPrefix != null){
            this.cssPrefix = cssPrefix;
        }else{
            this.cssPrefix = "mndlg_" + (Date.now()).getTime();
        }
        this.width = width;
        this.height = height;

        // cssの出力
        this.outputCSS(false);

        // エレメントの作成
        cssPrefix = this.cssPrefix + "_";
        // 背景
        divBG = document.createDivElement();
        divBG.className = cssPrefix + "bg";
        document.body.appendChild(divBG);
        // ウィンドウの土台
        divBase = document.createDivElement();
        divBase.className = cssPrefix + "base";
        if(this.id != ""){
            divBase.id = this.id;
        }
        divBG.appendChild(divBase);
        // ウィンドウのタイトル
        divTitle = document.createDivElement();
        divTitle.className = cssPrefix + "title";
        divTitle.textContent = "Title";
        divBase.appendChild(divTitle);
        // 表示内容
        divBody = document.createDivElement();
        // 世を忍ぶ仮の表示内容
        /*
        divBody.innerHTML = "Body<br>
        <ul>
        <li>aaa</li><li>bbb</li><li>ccc</li></ul>";
        */
        divBody.innerHTML = "";
        divBody.className = cssPrefix + "body";
        divBase.appendChild(divBody);
        // 下部ボタン用の領域
        divButtons = document.createDivElement();
        divButtons.className = cssPrefix + "buttons";
        divBase.appendChild(divButtons);
        // ボタン
        button1 = document.createButtonElement();
        button1.textContent = "OK";
        button1.value = "OK";
        button1.className = cssPrefix + "button";
        button1.name = "button1";
        divButtons.appendChild(button1);
        button2 = document.createButtonElement();
        button2.textContent = "Cancel";
        button2.value = "Cancel";
        button2.className = cssPrefix + "button";
        button2.name = "button2";
        divButtons.appendChild(button2);
        button3 = document.createButtonElement();
        button3.textContent = "NO!";
        button3.value = "No";
        button3.className = cssPrefix + "button";
        button3.name = "button3";
        divButtons.appendChild(button3);

        // ボタンの動作
        var evAction = "click";
        if(Reflect.hasField(js.Browser.window, "ontouchend")) evAction = "touchend";
        button1.addEventListener(evAction, function(){onButtonPress(button1);});
        button2.addEventListener(evAction, function(){onButtonPress(button2);});
        button3.addEventListener(evAction, function(){onButtonPress(button3);});
        /*
        button2.addEventListener(evAction, onButtonPress);
        button3.addEventListener(evAction, onButtonPress);
        */
    }

    public function setTitle(text:String){
        if(text != null){
            divTitle.textContent = text;
        }

    }

    public function setColor(colorBase, colorTitle, colorTitleText, colorButton){
        if(colorBase != null && colorBase != ""){
            this.colorBase = colorBase;
        }
        if(colorTitle != null && colorTitle != ""){
            this.colorTitle = colorTitle;
        }
        if(colorTitleText != null && colorTitleText != ""){
            this.colorTitleText = colorTitleText;
        }
        if(colorButton != null && colorButton != ""){
            this.colorButton = colorButton;
        }
        this.outputCSS();
    }

    public function outputCSS(delete:Bool = true){
        // CSS が存在していたら，更新のために削除する
        var oCSS = document.getElementById(this.cssPrefix);
        trace(oCSS);
        if(oCSS != null){
            if(!delete){
                trace("Canceled deletion of css: ", this.cssPrefix);
                return;
            }
            document.head.removeChild(oCSS);
        }

        var cssPrefix = this.cssPrefix + "_";
        /*
        if(this.id != ""){
            cssPrefix = "mndlg_" + this.id + "_";
        }else{
            cssPrefix = "mndlg_" + (Date.now()).getTime() + "_";
        }
        */
        /*
        var css = "." + cssPrefix + "bg{
    display: none;
    background-color: rgba(0, 0, 0, 0.2);
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}
." + cssPrefix + "base{
    position: absolute;
    left: 50%;
    top: 50%;
    width: " + this.width + "px;
    min-height: " + this.height + "px;
    transform: translate(-50%, -50%);
    background-color: " + colorBase + ";
    border: solid 2px " + colorTitle + ";
    border-radius: 4px;
}
." + cssPrefix + "title{
    background-color: " + colorTitle + ";
    color: " + colorTitleText + ";
    padding: 3px;
}
." + cssPrefix + "body{
    padding: 3px;
    height: " + (this.height - 60) + "px;
}
." + cssPrefix + "buttons{
    text-align: center;
    padding: 3px;
}
." + cssPrefix + "button{
    border-style: none;
    color: " + colorTitleText + ";
    background-color: " + colorTitle + ";
    cursor: pointer;
    border-radius: 4px;
    min-width: 40px;
}
." + cssPrefix + "button:hover{
    background-color: " + colorButton + ";
}";
*/
var css = '.${cssPrefix}bg{
    display: none;
    background-color: rgba(0, 0, 0, 0.2);
    position: fixed;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
}
.${cssPrefix}base{
    position: absolute;
    left: 50%;
    top: 50%;
    width: ${this.width}px;
    min-height: ${this.height}px;
    transform: translate(-50%, -50%);
    background-color: ${colorBase};
    border: solid 2px ${colorTitle};
    border-radius: 4px;
}
.${cssPrefix}title{
    background-color: ${colorTitle};
    color: ${colorTitleText};
    padding: 3px;
}
.${cssPrefix}body{
    padding: 3px;
    height: ${this.height - 60}px;
}
.${cssPrefix}buttons{
    text-align: center;
    padding: 3px;
}
.${cssPrefix}button{
    border-style: none;
    color: ${colorTitleText};
    background-color: ${colorTitle};
    cursor: pointer;
    border-radius: 4px;
    min-width: 40px;
}
.${cssPrefix}button:hover{
    background-color: ${colorButton};
}';


        var style = document.createStyleElement();
        style.id = this.cssPrefix;
        style.appendChild(document.createTextNode(css));
        document.head.appendChild(style);
        oCSS = document.getElementById(this.cssPrefix);
        trace(oCSS);
    }

    public function setButtonType(btType, lang){
        trace(btType);
        /*
        btType: OK OKCancel YesNo YesNoCancel
        lang: en ja 
        */
        button2.style.display = "none";
        button3.style.display = "none";
        switch(btType){
            case "OK":
            button1.textContent = "OK";
            button1.value = "OK";
            case "OKCancel":
            button1.textContent = "OK";
            button1.value = "OK";
            button2.style.display = "";
            button2.textContent = "キャンセル";
            button2.value = "Cancel";
            case "YesNo":
            button1.textContent = "はい";
            button1.value = "Yes";
            button2.style.display = "";
            button2.textContent = "いいえ";
            button2.value = "No";
            case "YesNoCancel":
            button1.textContent = "はい";
            button1.value = "Yes";
            button2.style.display = "";
            button2.textContent = "いいえ";
            button2.value = "No";
            button3.style.display = "";
            button3.textContent = "キャンセル";
            button3.value = "Cancel";
        }
    }

    public function setButtonCallback(cbFunc:js.lib.Function){
        this.cbButton = cbFunc;

    }

    public function show(){
        divBG.style.display = "block";
    }

    public function onButtonPress(button){
        divBG.style.display = "none";
        if(cbButton != null) cbButton.call(this, button.value);
    }
    public function onButtonPress_1(event:js.html.UIEvent){
        divBG.style.display = "none";
        if(cbButton != null) cbButton.call(this, event.target);
    }

}