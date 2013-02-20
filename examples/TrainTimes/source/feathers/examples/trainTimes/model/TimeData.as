package feathers.examples.trainTimes.model
{
	public class TimeData
	{
		public function TimeData(trainNumber:int, departureTime:Date, arrivalTime:Date)
		{
			this.trainNumber = trainNumber;
			this.departureTime = departureTime;
			this.arrivalTime = arrivalTime;
		}

		public var trainNumber:int;
		public var departureTime:Date;
		public var arrivalTime:Date;
	}
}
