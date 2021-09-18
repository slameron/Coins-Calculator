package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.text.TextFormatAlign;

class PlayState extends FlxState
{
	var pennies:Int = 0;
	var nickels:Int = 0;
	var dimes:Int = 0;
	var quarters:Int = 0;
	var dollars:Int = 0;

	var muni:Int = 0;

	var buttonList:FlxTypedGroup<FlxText>;

	var counterList:FlxTypedGroup<FlxText>;

	var curCoin:Int = 0;
	var curAdd:Int = 1;
	var curButton:Int = 0;
	var curText:String = "";

	var totalText:FlxText;

	var realMuni:String = "";
	var subButtons:Array<Dynamic> = [];
	var buttons:Array<Dynamic> = [
		["Add Penny", "Add Nickel", "Add Dime", "Add Quarter", "Add Dollar"],
		[
			"Remove Penny",
			"Remove Nickel",
			"Remove Dime",
			"Remove Quarter",
			"Remove Dollar"
		]
	];

	var counters:Array<String> = ["Pennies: ", "Nickels: ", "Dimes: ", "Quarters: ", "Dollars: ", "Total: "];

	override public function create()
	{
		totalText = new FlxText(0, 200, 0, "Total Money: ", 64);
		totalText.screenCenter(X);
		add(totalText);

		buttonList = new FlxTypedGroup<FlxText>();
		add(buttonList);

		// counterList = new FlxTypedGroup<FlxText>();
		// add(counterList);

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

	override public function update(elapsed:Float)
	{
		muni = (quarters * 25) + (dimes * 10) + (nickels * 5) + (pennies) + (dollars * 100);

		if (muni < 100 && muni > 10)
			realMuni = "0." + Std.string(muni).substr(0, 2);
		else if (muni < 10)
			realMuni = "0.0" + Std.string(muni).substr(0, 1);
		else if (muni < 1000)
			realMuni = Std.string(muni).substr(0, 1) + "." + Std.string(muni).substr(1, 2);
		else if (muni >= 1000)
			realMuni = Std.string(muni).substr(0, 2) + "." + Std.string(muni).substr(2, 2);

		if (muni >= 10000)
		{
			totalText.y = 125;
			totalText.alignment = CENTER;
			totalText.color = FlxColor.RED;
			totalText.size = 48;
			totalText.text = "u have more than 100 dollars\ni dont feel like counting anymore";
		}
		else
		{
			totalText.size = 64;
			totalText.y = 200;
			totalText.color = FlxColor.WHITE;
			totalText.text = "Total Money: $" + realMuni;
		}
		totalText.screenCenter(X);

		FlxG.watch.addQuick('Quarters', quarters);
		FlxG.watch.addQuick('Dimes', dimes);
		FlxG.watch.addQuick('nickels', nickels);
		FlxG.watch.addQuick('pennies', pennies);
		FlxG.watch.addQuick('dollars', dollars);
		FlxG.watch.addQuick('munni', muni);
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

		buttonList.forEach(function(txt:FlxText)
		{
			txt.color = FlxColor.WHITE;

			subButtons = buttons[curCoin];

			if (txt.ID == curAdd + (curCoin * 10))
			{
				txt.color = FlxColor.YELLOW;
				curText = txt.text;
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
					dollars++;

				case "Remove Quarter":
					quarters--;
				case "Remove Nickel":
					nickels--;
				case "Remove Dime":
					dimes--;
				case "Remove Penny":
					pennies--;
				case "Remove Dollar":
					dollars--;
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			quarters = pennies = nickels = dimes = dollars = muni = 0;
			realMuni = "0.00";
		}
	}
}
