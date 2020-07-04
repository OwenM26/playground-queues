import UIKit

// Intro to Grand Central Dispatch (GCD)

// ---------------------------------------------------------------------------------

// Always use this when updating to prevent crashes or weird behaviours, the console should also warn you if you're not on the main thread with a console log statement as well as a purple thread indicator.

DispatchQueue.main.async {
    // update UI here, e.g reload collectionView or update image etc
}

// --------------------------------------------------------------------------------

/*
   The first line creates a queue with the lowest quality of service ".background" this can be changed to any of the default options like ".userInitiated" and ".userInteractive" depending on the importance of the data.
 
   Running multiple tasks on a queue using async will take advantage of the CPU's cores on the device to run the tasks simultaneously. Running the playgroud in it's current state will show that the printing of the numbers in the console and the characters and ran side by side.
 
   Challenge - See if you can make the backgroundQueue execute the printing of numbers 0 -> 9 first and then print the characters after.
   Hint - Knowing the opposite of an asynchronous or concurrent queue will help and autocomplete should be able to help you out.
*/

let backgroundQueue = DispatchQueue.global(qos: .background)

backgroundQueue.async {
    for i in 0..<10 {
        print(i)
    }
}

backgroundQueue.async {
    for (index, character) in "hello".enumerated() {
        print("Character: \(character) at index: \(index)")
    }
}

// ------------------------------------------------------------------------------------------

/*
   Swift is also kind and allows us to create our own queues, this can be useful when debugging your app to see which queue is executing your current tasks.

   When intialising a queue we can also set the QOS just like the default global queue above.
*/

let myQueue = DispatchQueue(label: "Owen's Queue")
let qosQueue = DispatchQueue(label: "Owen's Queue 2", qos: .userInitiated)

// ------------------------------------------------------------------------------------------
print("-----------------------------------------------------------------------------")

/*
   If you're unsure about which thread you're currently executing code on you can do this.
*/

let currentThread = Thread.current
print(currentThread)

// ------------------------------------------------------------------------------------------
print("-----------------------------------------------------------------------------")

/*
   GCD is good, until you need to cancel or pause a specific task or queue. GCD ensures that any tasks added to a queue will be executed at some point thus meaning we cannot cancel a task that has been added.
  
   This is where we can use an operation queue - It's more versatile and allows use to tell the compiler how many tasks we would like to be running at once, we can pause the thread, and stop all tasks.
 
   You should note that OperationQueue is built upon GCD but provides a more versatile way of creating an managing a queue.
*/

let operationQueue = OperationQueue()
operationQueue.name = "Owen's Operation Queue" // We can name the queue just like above
operationQueue.qualityOfService = .background // We can set the QOS
operationQueue.maxConcurrentOperationCount = 5 // 5 tasks can all run at the same time
operationQueue.isSuspended = true // We can suspend the queue or pause the queue from running
operationQueue.cancelAllOperations() // We can cancel the queues tasks
operationQueue.waitUntilAllOperationsAreFinished() // We can stop all the code in scope from running until the queue is finished.

// Lets see a practical example

func createAndRunOperationQueue() {
    let owensOperationQueue = OperationQueue()
    owensOperationQueue.name = "Owen's Queue"
    owensOperationQueue.maxConcurrentOperationCount = 1 // Change this number to 2 and see what happens in the console log below, you can see that the queue now executes the tasks side by side or asynchronously.

    owensOperationQueue.addOperation {
        for i in 0..<100 {
            print(i)
        }
    }

    owensOperationQueue.addOperation {
        for (index, character) in "This is the operation queue test".enumerated() {
            print("Character: \(character) at index: \(index)")
        }
    }
    
    owensOperationQueue.waitUntilAllOperationsAreFinished()
    
    print("Then all tasks are finished") // Note that the queue also waits until it's finished to execute this line because of the ".waitUntilAllOperationsAreFinished()" function.
}

createAndRunOperationQueue()
