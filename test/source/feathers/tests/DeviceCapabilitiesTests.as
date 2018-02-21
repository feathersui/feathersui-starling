package feathers.tests
{	
	import feathers.system.DeviceCapabilities;
	
	import org.flexunit.Assert;

	public class DeviceCapabilitiesTests
	{
		//Resolution and DPI data collected from http://dpi.lv
		private const IOS_DEVICES:Array = 
			[
				//iphone
				{
					deviceName: "iPhone 1, 3G, 3Gs", 
					resolution: [320,480],
					dpi: 163,
					isLargePhone: false,
					isTablet: false,
					orientation: "Portrait"
				},
				{
					deviceName: "iPhone 4,4s", 
					resolution: [640,960],
					dpi: 326,
					isLargePhone: false,
					isTablet: false,
					orientation: "Portrait"
				},
				{
					deviceName: "iPhone 5,5c,5s", 
					resolution: [640,1136],
					dpi: 326,
					isLargePhone: false,
					isTablet: false,
					orientation: "Portrait"
				},
				{
					deviceName: "iPhone 6, 7, 8", 
					resolution: [750,1334],
					dpi: 326,
					isLargePhone: false,
					isTablet: false,
					orientation: "Portrait"
				},
				{
					deviceName: "iPhone 6+, 7+, 8+", 
					resolution: [1242,2208],
					dpi: 401,
					isLargePhone: true,
					isTablet: false,
					orientation: "Portrait"
				},
				{
					deviceName: "iPhone 6+, 7+, 8+",
					dpi: 401,
					resolution: [2208,1242],
					isLargePhone: true,
					isTablet: false,
					orientation: "Landscape"
				},
				{
					deviceName: "iPhone X", 
					resolution: [1125,2436],
					dpi: 458,
					isLargePhone: false,
					isTablet: false,
					orientation: "Portrait"
				},
				{
					deviceName: "iPhone X", 
					resolution: [2436,1125],
					dpi: 458,
					isLargePhone: false,
					isTablet: false,
					orientation: "Landscape"
				},
				
				//ipad
				{
					deviceName: "iPad 1,2", 
					resolution: [768,1024],
					dpi: 132,
					isLargePhone: false,
					isTablet: true,
					orientation: "Portrait"
				},
				{
					deviceName: "iPad 1,2", 
					resolution: [1024,768],
					dpi: 132,
					isLargePhone: false,
					isTablet: true,
					orientation: "Landscape"
				},
				{
					deviceName: "iPad mini", 
					resolution: [768,1024],
					dpi: 163,
					isLargePhone: false,
					isTablet: true,
					orientation: "Portrait"
				},
				{
					deviceName: "iPad mini", 
					resolution: [1024,768],
					dpi: 163,
					isLargePhone: false,
					isTablet: true,
					orientation: "Landscape"
				},
				{
					deviceName: "iPad mini retina", 
					resolution: [1536,2048],
					dpi: 324,
					isLargePhone: false,
					isTablet: true,
					orientation: "Portrait"
				},
				{
					deviceName: "iPad mini retina", 
					resolution: [2048,1536],
					dpi: 324,
					isLargePhone: false,
					isTablet: true,
					orientation: "Landscape"
				},

				{
					deviceName: "iPad 3,Air", 
					resolution: [1536,2048],
					dpi: 264,
					isLargePhone: false,
					isTablet: true,
					orientation: "Portrait"
				},
				{
					deviceName: "iPad 3,Air", 
					resolution: [2048,1536],
					dpi: 264,
					isLargePhone: false,
					isTablet: true,
					orientation: "Landscape"
				},
				{
					deviceName: "iPad Pro (10.5″)", 
					resolution: [1668,2224],
					dpi: 264,
					isLargePhone: false,
					isTablet: true,
					orientation: "Portrait"
				},
				{
					deviceName: "iPad Pro (10.5″)", 
					resolution: [2224,1668],
					dpi: 264,
					isLargePhone: false,
					isTablet: true,
					orientation: "Landscape"
				},
				{
					deviceName: "iPad Pro (12.9″)", 
					resolution: [2048,2732],
					dpi: 264,
					isLargePhone: false,
					isTablet: true,
					orientation: "Portrait"
				},
				{
					deviceName: "iPad Pro (12.9″)", 
					resolution: [2732,2048],
					dpi: 264,
					isLargePhone: false,
					isTablet: true,
					orientation: "Landscape"
				}
			]

		[Before]
		public function prepare():void
		{
			
		}

		[After]
		public function cleanup():void
		{
			
		}

		[Test]
		public function testDeviceTypes():void
		{
			
			for each (var device:Object in IOS_DEVICES)
			{
				DeviceCapabilities.dpi = device.dpi;
				DeviceCapabilities.screenPixelWidth = device.resolution[0];
				DeviceCapabilities.screenPixelHeight = device.resolution[1];
				var isTablet:Boolean = DeviceCapabilities.isTablet();
				var isLargePhone:Boolean = DeviceCapabilities.isLargePhone();
				Assert.assertFalse(device.deviceName+" detection failed at orientation "+device.orientation+" as TABLET", isTablet != device.isTablet);
				Assert.assertFalse(device.deviceName+" detection failed at orientation "+device.orientation+" as LARGE PHONE", isLargePhone != device.isLargePhone);
			}		
		}
	}
}
