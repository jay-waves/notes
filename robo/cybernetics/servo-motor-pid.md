

## Motor Types 

## PID Control 

```
Target position
   ↓
Position PID
   ↓ target speed
Speed PID
   ↓ target torque/current
Current PID
   ↓ PWM / voltage
Motor
```

The Inner Loop must be tuned first and be faster. In practice, **current is roughly propoertional to current**. 


## Step Response Position Loop Tunning

![](../../attach/img/robo/position-pid-loop.avif)

Position Loop tuning goal is to set the Kp to as high a value as possible while still finding an associated Kd that can create a critically damped response. Higher Kp value will result in more accurate tracking and faster responses to command position changesl.

*Step Response* Tunning Prcedures:
1. set up the facility to measure *motion trace* : $\Delta q$
2. set up the ccontroller to make an instantaneous move from current postion to a programmed destination. **limit the step distance to avoid the current exceeding ampilifier command value**.
3. Set Ki to 0, Set Kp to a small value, Set the Kd to value 5 times the specified Kp value. Set xxx_ff (feedforward gain) to 0.
4. Execute the instantaneous step move. 

The actual profiles should try to avoid instantaneous changes of position to minimize resonant vibration.

#### Acceleration and Velocity Feedforward 

PID is **reactive**: it corrects error only after the output has alraady deviated. Feedforward is **predictive**: it acts before the error appears, based on known disturbances.

* increse speed of response 
* reduce overshoot, and avoid a large *ki* building up.


## Brake 

## References 

https://www.pmdcorp.com/resources/type/articles/get/how-to-tune-a-pid-loop
