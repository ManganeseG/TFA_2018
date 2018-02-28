using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Characters : MonoBehaviour
{
    private float horizontalMove;
    private float verticalMove;
    private float velocity;
    private Quaternion previousRotation = Quaternion.identity;
    private Rigidbody rigidBody;
    public bool canJump = false;


    public float CurrentMoveSpeed;
    public float MoveSpeed = 1.0f;
    [Range(1.0f, 6.0f)]
    public float JumpForce = 10.0f;   
    public float SprintSpeed = 5f;
    [Range(0f, 1f)]
    public float RotationSmoothness = 0.5f;
    public GameObject partSystem;
    

    public enum WhichCharacter
    {
        Erwin,
        Arjuna,
        Tanvir,
        Mallika
    }
    public WhichCharacter SelectedCharacter = WhichCharacter.Erwin;


    void Start()
    {
        rigidBody = GetComponent<Rigidbody>();


    }

    private void FixedUpdate()
    {
        move();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftShift))
        {
            partSystem.SetActive(true);
        }
    }

    private void move()
    {

        CurrentMoveSpeed = MoveSpeed;
        velocity = rigidBody.velocity.y;
        float horizontalMove = Input.GetAxis("Horizontal");
        float verticalMove = Input.GetAxis("Vertical");
        float length = Mathf.Sqrt(horizontalMove * horizontalMove +
            verticalMove * verticalMove);

        length = Mathf.Max(length, 1f);

        if (Input.GetKey(KeyCode.LeftShift))
        {
            CurrentMoveSpeed = SprintSpeed;
        }
        


        horizontalMove *= Time.deltaTime * CurrentMoveSpeed / length;
        verticalMove *= Time.deltaTime * CurrentMoveSpeed / length;

        Vector3 deltaPosition = new
        Vector3(horizontalMove, 0f, verticalMove);

        RaycastHit hitInfoH, hitInfoV;

        bool collisionH = Physics.SphereCast(transform.position, 0.5f,
                                Vector3.right * Mathf.Sign(deltaPosition.x), out hitInfoH,
                                Mathf.Abs(deltaPosition.x) + 0.5f, 1 << 12, QueryTriggerInteraction.Collide);
        bool collisionV = Physics.SphereCast(transform.position, 0.5f,
                                Vector3.forward * Mathf.Sign(deltaPosition.z), out hitInfoV,
                                Mathf.Abs(deltaPosition.z) + 0.5f, 1 << 12, QueryTriggerInteraction.Collide);

        if (collisionH)
        {
            deltaPosition.x = Mathf.Sign(deltaPosition.x) * (hitInfoH.distance - 0.5f);
        }
        if (collisionV)
        {
            deltaPosition.z = Mathf.Sign(deltaPosition.z) * (hitInfoV.distance - 0.5f);
        }

        Vector3 position = rigidBody.position +
            deltaPosition;

        Quaternion rotation;
        if (deltaPosition.magnitude > 0.01f)
        {
            rotation = Quaternion.LookRotation(
                deltaPosition.normalized);
        }
        else
        {
            rotation = previousRotation;
        }

        rigidBody.MovePosition(position);
        rigidBody.MoveRotation(Quaternion.Slerp(
            rigidBody.rotation, rotation, RotationSmoothness));

        previousRotation = rigidBody.rotation;
        
        if (Input.GetButtonDown("Jump") && canJump)
        {
            rigidBody.velocity = new Vector3(0, JumpForce, 0);
        }
    }
    void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Ground"))
        {
            canJump = true;
        }
    }
    void OnTriggerExit(Collider col)
    {
        if (col.gameObject.layer == LayerMask.NameToLayer("Ground"))
        {
            canJump = false;
        }
    }
}
