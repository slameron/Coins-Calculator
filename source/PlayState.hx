package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.ui.FlxButton.FlxTypedButton;
import flixel.util.FlxColor;
import openfl.text.TextFormatAlign;

using StringTools;

class PlayState extends FlxState
{
	var pennies:Int = 0;
	var nickels:Int = 0;
	var dimes:Int = 0;
	var quarters:Int = 0;
	var halves:Int = 0;
	var fulls:Int = 0;
	var dollars:Int = 0;
	var fives:Int = 0;
	var tens:Int = 0;
	var twenties:Int = 0;
	var fifties:Int = 0;
	var hundreds:Int = 0;
	var muni:Int = 0;

	var buttonList:FlxTypedGroup<FlxText>;
	var pageList:FlxTypedGroup<FlxText>;

	var counterList:FlxTypedGroup<FlxText>;

	var curCoin:Int = 0;
	var curPage:Int = 0;

	var curAdd:Int = 1;
	var curButton:Int = 0;
	var curText:String = "";

	var totalText:FlxText;

	var realMuni:String = "";
	var pages:Array<String> = ["Coins", "Bills"];
	var coinTypes:Array<String> = ["Penny", "Nickel", "Dime", "Quarter", "Half-Dollar", "Dollar"];
	var billTypes:Array<String> = ["One", "Five", "Ten", "Twenty", "Fifty", "Hundred"];
	var subButtons:Array<Dynamic> = [];
	var buttons:Array<Dynamic> = [];

	var counters:Array<String> = ["Pennies: ", "Nickels: ", "Dimes: ", "Quarters: ", "Dollars: ", "Total: "];

	override public function create()
	{
		if (pages[curPage] == "Coins")
		{
			for (i in 0...coinTypes.length)
			{
				subButtons.push("Add " + coinTypes[i]);
				FlxG.log.add("added " + coinTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];
			for (i in 0...coinTypes.length)
			{
				subButtons.push("Remove " + coinTypes[i]);
				FlxG.log.add("added " + coinTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];
		}
		else
		{
			for (i in 0...billTypes.length)
			{
				subButtons.push("Add " + billTypes[i]);
				FlxG.log.add("added " + billTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];

			for (i in 0...billTypes.length)
			{
				subButtons.push("Remove " + billTypes[i]);
				FlxG.log.add("added " + billTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];
		}

		totalText = new FlxText(0, 20, 0, "Total Money: ", 64);
		totalText.screenCenter(X);
		add(totalText);

		buttonList = new FlxTypedGroup<FlxText>();
		add(buttonList);
		pageList = new FlxTypedGroup();
		add(pageList);

		// counterList = new FlxTypedGroup<FlxText>();
		// add(counterList);

		for (i in 0...pages.length)
		{
			var text:FlxText = new FlxText(0, 0, 0, pages[i], 38);
			text.setPosition((FlxG.width / 2 - text.width / 2) - FlxG.width / 8 + (FlxG.width / 4 * i - 1), totalText.y + totalText.height + 20);
			text.ID = i;
			pageList.add(text);
		}
		for (buttonRows in 0...buttons.length)
		{
			subButtons = buttons[buttonRows];

			for (buttonContent in 0...subButtons.length)
			{
				var button:FlxText = new FlxText(0, 0, 0, subButtons[buttonContent], 32);
				button.setPosition((FlxG.width / 2 - button.width / 2) - FlxG.width / 8 + (FlxG.width / 4 * buttonRows - 1), 300 + 50 * buttonContent);
				button.ID = (buttonRows * 10) + (buttonContent + 1);
				buttonList.add(button);
			}
		}

		super.create();
	}

	function swapPage()
	{
		buttons = [];
		subButtons = [];
		buttonList.forEach(function(txt:FlxText)
		{
			buttonList.remove(txt);
		});
		if (pages[curPage] == "Coins")
		{
			for (i in 0...coinTypes.length)
			{
				subButtons.push("Add " + coinTypes[i]);
				// FlxG.log.add("added " + coinTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];
			for (i in 0...coinTypes.length)
			{
				subButtons.push("Remove " + coinTypes[i]);
				// FlxG.log.add("added " + coinTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];
		}
		else
		{
			for (i in 0...billTypes.length)
			{
				subButtons.push("Add " + billTypes[i]);
				// FlxG.log.add("added " + billTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];

			for (i in 0...billTypes.length)
			{
				subButtons.push("Remove " + billTypes[i]);
				//	FlxG.log.add("added " + billTypes[i]);
			}
			buttons.push(subButtons);
			subButtons = [];
		}

		for (buttonRows in 0...buttons.length)
		{
			subButtons = buttons[buttonRows];

			for (buttonContent in 0...subButtons.length)
			{
				var button:FlxText = new FlxText(0, 0, 0, subButtons[buttonContent], 32);
				button.setPosition((FlxG.width / 2 - button.width / 2) - FlxG.width / 8 + (FlxG.width / 4 * buttonRows - 1), 300 + 50 * buttonContent);
				button.ID = (buttonRows * 10) + (buttonContent + 1);
				buttonList.add(button);
			}
		}
	}

	override public function update(elapsed:Float)
	{
		muni = 0 + (quarters * 25) + (dimes * 10) + (nickels * 5) + (pennies) + (dollars * 100) + (fulls * 100) + (halves * 50) + (fives * 500)
			+ (tens * 1000) + (twenties * 2000) + (fifties * 5000) + (hundreds * 10000);
		FlxG.watch.addQuick("??", muni);
		var muniThing:String = Std.string(muni);

		if (muni < 100 && muni > 10)
			realMuni = "0." + Std.string(muni).substr(0, 2);
		else if (muni < 10)
			realMuni = "0.0" + Std.string(muni).substr(0, 1);
		else if (muni < 1000)
			realMuni = Std.string(muni).substr(0, 1) + "." + Std.string(muni).substr(1, 2);
		else if (muni >= 1000)
			realMuni = Std.string(muni).substr(0, muniThing.length - 2) + "." + Std.string(muni).substr(muniThing.length - 2, 2);

		totalText.size = 64;
		totalText.y = 20;
		totalText.color = FlxColor.WHITE;
		totalText.text = "Total Money: $" + realMuni;

		totalText.screenCenter(X);

		FlxG.watch.addQuick('um', buttons);
		FlxG.watch.addQuick('uh', subButtons);
		FlxG.watch.addQuick('length', buttonList.length);

		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([UP, W]))
			curAdd -= 1;
		// FlxG.sound.play(Paths.sound('scrollMenu'));

		if (FlxG.keys.anyJustPressed([DOWN, S]))
			curAdd += 1;
		// FlxG.sound.play(Paths.sound('scrollMenu'));

		if (curAdd < 1)
			curAdd = subButtons.length;

		if (curAdd >= subButtons.length + 1)
			curAdd = 1;

		// levels selector
		if (FlxG.keys.anyJustPressed([LEFT, A]))
			curCoin -= 1;
		// FlxG.sound.play(Paths.sound('scrollMenu'));

		if (FlxG.keys.anyJustPressed([RIGHT, D]))
			curCoin += 1;
		// FlxG.sound.play(Paths.sound('scrollMenu'));

		if (curCoin < 0)
			curCoin = buttons.length - 1;

		if (curCoin >= buttons.length)
			curCoin = 0;

		if (FlxG.keys.justPressed.Q)
		{
			if (curPage - 1 == -1)
				curPage = pages.length - 1;
			else
				curPage--;
			swapPage();
		}
		if (FlxG.keys.justPressed.E)
		{
			if (curPage + 1 == pages.length)
				curPage = 0;
			else
				curPage++;

			swapPage();
		}

		buttonList.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			// subButtons = buttons[curCoin];

			if (txt.ID == curAdd + (curCoin * 10))
			{
				txt.color = FlxColor.YELLOW;
				curText = txt.text.trim();
				FlxG.watch.addQuick("TF", "'" + curText + "'");
			}
		});

		pageList.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curPage)
			{
				txt.color = FlxColor.YELLOW;
				// curText = txt.text;
			}
		});

		curButton = (curCoin * 10) + curAdd + 10;

		if (dollars < 0)
			dollars = 0;
		if (pennies < 0)
			pennies = 0;
		if (dimes < 0)
			dimes = 0;
		if (quarters < 0)
			quarters = 0;
		if (nickels < 0)
			nickels = 0;
		if (halves < 0)
			halves = 0;
		if (fulls < 0)
			fulls = 0;
		if (fives < 0)
			fives = 0;
		if (tens < 0)
			tens = 0;
		if (twenties < 0)
			twenties = 0;
		if (fifties < 0)
			fifties = 0;
		if (hundreds < 0)
			hundreds = 0;

		if (FlxG.keys.anyJustPressed([SPACE, ENTER]))
		{
			switch (curText)
			{
				case "Add Quarter":
					quarters++;
				case "Add Nickel":
					nickels++;
				case "Add Dime":
					dimes++;
				case "Add Penny":
					pennies++;
				case "Add Dollar":
					fulls++;
				case "Add Half-Dollar":
					halves++;
				case "Add Five":
					fives++;
				case "Add One":
					dollars++;
				case "Add Ten":
					tens++;
				case "Add Twenty":
					twenties++;
				case "Add Fifty":
					fifties++;
				case "Add Hundred":
					hundreds++;

				case "Remove Quarter":
					quarters--;
				case "Remove Nickel":
					nickels--;
				case "Remove Dime":
					dimes--;
				case "Remove Penny":
					pennies--;
				case "Remove Dollar":
					fulls--;
				case "Remove Half-Dollar":
					halves--;
				case "Remove Five":
					fives--;
				case "Remove One":
					dollars--;
				case "Remove Ten":
					tens--;
				case "Remove Twenty":
					twenties--;
				case "Remove Fifty":
					fifties--;
				case "Remove Hundred":
					hundreds--;
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			fives = tens = twenties = halves = fulls = hundreds = fifties = quarters = pennies = nickels = dimes = dollars = muni = 0;
			realMuni = "0.00";
		}
	}
}
