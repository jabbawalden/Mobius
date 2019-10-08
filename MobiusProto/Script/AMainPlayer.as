class AMainPlayer : APawn
{
    UPROPERTY(DefaultComponent, RootComponent)
    UBoxComponent BoxCollision;

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    UStaticMeshComponent MeshComp;

    UPROPERTY(DefaultComponent)
    UInputComponent InputComp;

    UPROPERTY(DefaultComponent, Attach = BoxCollision)
    USpringArmComponent SpringArm;
    default SpringArm.TargetArmLength = 1000;  

    UPROPERTY(DefaultComponent, Attach = SpringArm)
    UCameraComponent MainCamera;

    UFUNCTION(BlueprintOverride)
    void ConstructionScript()
    {
        SpringArm.SetRelativeRotation(FRotator(-30, 0, 0));
    }

    UFUNCTION(BlueprintOverride)
    void BeginPlay()
    {
        Print("Player is here", 5);
        PlayerInputSetup();
    }

    UFUNCTION(BlueprintOverride)
    void Tick(float DeltaSeconds) 
    {
        
    }

    UFUNCTION()
    void PlayerInputSetup()
    {
        InputComp.BindAxis(n"MoveRight", FInputAxisHandlerDynamicSignature(this, n"MoveSides"));
    }

    UFUNCTION()
    void MoveSides(float AxisValue)
    {
        AddMovementInput(ControlRotation.RightVector, AxisValue);
    }
} 