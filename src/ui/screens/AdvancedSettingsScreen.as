package ui.screens
{
	import flash.system.System;
	
	import feathers.controls.DragGesture;
	import feathers.controls.Label;
	import feathers.themes.BaseMaterialDeepGreyAmberMobileTheme;
	import feathers.themes.MaterialDeepGreyAmberMobileThemeIcons;
	
	import model.ModelLocator;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	import ui.AppInterface;
	import ui.screens.display.LayoutFactory;
	import ui.screens.display.settings.advanced.DeepSleepSettingsList;
	
	import utils.Constants;
	
	[ResourceBundle("advancedsettingsscreen")]

	public class AdvancedSettingsScreen extends BaseSubScreen
	{
		/* Display Objects */
		private var deepSleepSettings:DeepSleepSettingsList;
		private var deepSleepLabel:Label;
		
		public function AdvancedSettingsScreen() 
		{
			super();
			
			setupHeader();	
		}
		override protected function initialize():void 
		{
			super.initialize();
			
			setupContent();
		}
		
		/**
		 * Functionality
		 */
		private function setupHeader():void
		{
			/* Set Header Title */
			title = ModelLocator.resourceManagerInstance.getString('advancedsettingsscreen','advanced_screen_title');
			
			/* Set Header Icon */
			icon = getScreenIcon(MaterialDeepGreyAmberMobileThemeIcons.settingsCellTexture);
			iconContainer = new <DisplayObject>[icon];
			headerProperties.rightItems = iconContainer;
		}
		
		private function setupContent():void
		{
			//Deactivate menu drag gesture 
			AppInterface.instance.drawers.openGesture = DragGesture.NONE;
			
			//Deep Slepp Section Label
			deepSleepLabel = LayoutFactory.createSectionLabel(ModelLocator.resourceManagerInstance.getString('advancedsettingsscreen','prevent_suspension_title'), true);
			screenRenderer.addChild(deepSleepLabel);
			
			//24H Distribution Settings
			deepSleepSettings = new DeepSleepSettingsList();
			screenRenderer.addChild(deepSleepSettings);
		}
		
		/**
		 * Event Handlers
		 */
		override protected function onBackButtonTriggered(event:Event):void
		{
			//Save Settings
			if (deepSleepSettings.needsSave)
				deepSleepSettings.save();
			
			//Activate menu drag gesture
			AppInterface.instance.drawers.openGesture = DragGesture.EDGE;
			
			//Pop Screen
			dispatchEventWith(Event.COMPLETE);
		}
		
		/**
		 * Utility
		 */
		override public function dispose():void
		{
			if (deepSleepLabel != null)
			{
				deepSleepLabel.removeFromParent();
				deepSleepLabel.dispose();
				deepSleepLabel = null;
			}
			
			if (deepSleepSettings != null)
			{
				deepSleepSettings.removeFromParent();
				deepSleepSettings.dispose();
				deepSleepSettings = null;
			}
			
			super.dispose();
			
			System.pauseForGCIfCollectionImminent(0);
		}
		
		override protected function draw():void 
		{
			super.draw();
			icon.x = Constants.stageWidth - icon.width - BaseMaterialDeepGreyAmberMobileTheme.defaultPanelPadding;
		}
	}
}